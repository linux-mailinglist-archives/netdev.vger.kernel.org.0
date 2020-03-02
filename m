Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA792175266
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgCBDwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:52:16 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40038 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCBDwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:52:16 -0500
Received: by mail-qk1-f194.google.com with SMTP id m2so8780064qka.7
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+cdJF0brR/vihABWmrIJXiarg98NoQjihPhfiMwaEPQ=;
        b=HNqdSqP/dbTbnSBLsKgXhpw7UKjm+l3xT0mLgHHmbIzlajOwUWPcT5x9PBXizRyUGZ
         9xxemAMlsr1UeczrdtQSNpkByf7tmgkk9G7tIRz0A1JcuVcuuxsWNUuDzICYl2IZEynu
         DY2cEGx855kDDyxRMkrVznzkM+3KGj9mhu69ePL8fwJFnDOYhWIv4NiAo212l47fVQd3
         1J+M842XpIhmOXeKE1UxGbGO10GHDEE+XXp/3oDF55uGkLNKm210FUKm0kd7cLeZy+xM
         A32xShDSZZ2RWVD8ozKBBe/1IyXlyWC0vqYSWH33jL8JL7yCVfUnRE9c7DL4Dm36GwtU
         aZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+cdJF0brR/vihABWmrIJXiarg98NoQjihPhfiMwaEPQ=;
        b=V2Z1yNuUlnolE259SWvkShocJvMqDa5m7n3N1U9PAYeT2mZuBb/a1OkdpkOaJdi7t7
         VQtP1u0pPiHO0NQ5fg11XvSRHy2nH6MTXW7cubbk0HNEVVemQDrb2gabp1QT+eCMjGr1
         16xyU80OjVlDSLYULb764iZh+v2MQkTtJQ6aUKpOmTsiNmb5gvacPXIoexCERV8bbhV+
         Dv6q5IWMw/xJizX0fneO6T1hpz58CpzP8hGOAv7ZvCX9FHDb/zgebrGWqlhZnhkoD0A+
         Zx7aMml7iYVUooL/A71g9bnMLfvNhazYS6frCiNoKV+lcihjtr+RQ0XeUTt6t7m8tjWw
         xTMw==
X-Gm-Message-State: APjAAAUykmjkWPxfivOYIE6c7jFWQYFUyv0KHXIEf6e3T7RPZTq8jKDP
        3/CITuvUCugbT7o87WH0NbU=
X-Google-Smtp-Source: APXvYqzB9nH4ADoSM1oEfLFVp0QDc4tOp+zPIlmnWjoWAe143At2qaWt+DAA+03hob6LZDdQ+ltiXQ==
X-Received: by 2002:a37:9104:: with SMTP id t4mr15226914qkd.449.1583121134084;
        Sun, 01 Mar 2020 19:52:14 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:d978:6c79:25cd:dedf? ([2601:282:803:7700:d978:6c79:25cd:dedf])
        by smtp.googlemail.com with ESMTPSA id s139sm5563402qke.70.2020.03.01.19.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 19:52:13 -0800 (PST)
Subject: Re: [PATCH RFC v4 bpf-next 07/11] tun: set egress XDP program
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-8-dsahern@kernel.org>
 <25d0253e-d1b8-ca6c-4e2f-3e5c35d6d661@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2f2e522c-b5e1-0c65-147f-f602bca76f18@gmail.com>
Date:   Sun, 1 Mar 2020 20:52:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <25d0253e-d1b8-ca6c-4e2f-3e5c35d6d661@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/1/20 8:32 PM, Jason Wang wrote:
>> @@ -1189,15 +1190,21 @@ tun_net_get_stats64(struct net_device *dev,
>> struct rtnl_link_stats64 *stats)
>>   }
>>     static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>> -               struct netlink_ext_ack *extack)
> 
> 
> How about accept a bpf_prog ** here, then there's no need to check
> egress when deferencing the pointer?


sure, that works. Will change.

> 
> 
>> +               bool egress, struct netlink_ext_ack *extack)
>>   {
>>       struct tun_struct *tun = netdev_priv(dev);
>>       struct tun_file *tfile;
>>       struct bpf_prog *old_prog;
>>       int i;
>>   -    old_prog = rtnl_dereference(tun->xdp_prog);
>> -    rcu_assign_pointer(tun->xdp_prog, prog);
>> +    if (egress) {
>> +        old_prog = rtnl_dereference(tun->xdp_egress_prog);
>> +        rcu_assign_pointer(tun->xdp_egress_prog, prog);
>> +    } else {
>> +        old_prog = rtnl_dereference(tun->xdp_prog);
>> +        rcu_assign_pointer(tun->xdp_prog, prog);
>> +    }
>> +
>>       if (old_prog)
>>           bpf_prog_put(old_prog);
> 
> 
> Btw, for egress type of XDP there's no need to toggle SOCK_XDP flag
> which is only needed for RX XDP.

Right. We removed the manipulation of that flag a few iterations ago
based on a review comment.


