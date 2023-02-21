Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2214D69E911
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 21:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjBUUke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 15:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjBUUkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 15:40:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC63F2D142
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 12:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677011974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YdDNg00iZDLT5J47DaIV5Cp6ABia2XUtMExirMnXrTw=;
        b=GHjGteO7cUjOork37g7sv9qshXqIzPpFHekaScZ/v8uJ2FkbCk6bvn8osJk6Ee4H/vFmLU
        ys9GLUpHKPxp0DnnDzhoTGBzw214V8jWr+ttGdRTosOl/wVc3RvIwpXjlr76/OOkgQjoAv
        r78WTzDmUR67GUD95mq5iEFNQAISniU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-149-7si8tX1vO06QJf0ytpJxQQ-1; Tue, 21 Feb 2023 15:39:33 -0500
X-MC-Unique: 7si8tX1vO06QJf0ytpJxQQ-1
Received: by mail-ed1-f69.google.com with SMTP id dm14-20020a05640222ce00b0046790cd9082so7990763edb.21
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 12:39:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YdDNg00iZDLT5J47DaIV5Cp6ABia2XUtMExirMnXrTw=;
        b=gUEud88jQnnj/D1hqb2qCaztkUDKdn++scwMG9bh8206pLG744xob3aschw1/VJATe
         ugvSnQ13aiD9QoCtx9Ncm9REi0xlQLxvCmwgTvga23izH2WTnRw0Z37Blnk6o3LsW9aA
         XWxMVDR+s4HlzAuW5Pg+66sLecbvK8cHnHME3G2l5wwvbiW8YwYOv/+H96jzbnsNxurS
         9w8kz3jSNQhxdyq+W7jwxuoYB54Fhae/k/Qk5JOmBkOc/mXoF6w2eW7zKSkuaLeWynB9
         EIs9vWgx7E7HqlP7rtRxrFQZSbIak2FdtcXKDkiqnT01e01ycxT921JBcnp0AFZOvCc5
         Qr1Q==
X-Gm-Message-State: AO0yUKVEduqkrGD9GtRqOwqqg6TddbWJspLYc2Zyam2W8F9EST9dQ182
        Rj4Onu8hDJD5YAYpAicbcM35fSjsdyvJrXUsmWaoFBKqeNqegMVNxk+g6aR8BmjRfiGhZpi87t7
        GH5L7nkIMe4VdT7N3
X-Received: by 2002:a17:907:10d4:b0:8b2:abc7:1ef9 with SMTP id rv20-20020a17090710d400b008b2abc71ef9mr16128573ejb.68.1677011972382;
        Tue, 21 Feb 2023 12:39:32 -0800 (PST)
X-Google-Smtp-Source: AK7set9nOVg3U99yGFw2+SlKsMkpS0fRMtupqBJv0UiozrsOwvtrTX4oFk1IAIZPOdTvhDDoW0o0XQ==
X-Received: by 2002:a17:907:10d4:b0:8b2:abc7:1ef9 with SMTP id rv20-20020a17090710d400b008b2abc71ef9mr16128557ejb.68.1677011972026;
        Tue, 21 Feb 2023 12:39:32 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id n21-20020a170906119500b008e09deb6610sm1019154eja.200.2023.02.21.12.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 12:39:31 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <613bbdb0-e7b0-59df-f2ee-6c689b15fe41@redhat.com>
Date:   Tue, 21 Feb 2023 21:39:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net
Subject: Re: [PATCH bpf-next V3] xdp: bpf_xdp_metadata use EOPNOTSUPP for no
 driver support
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
References: <167673444093.2179692.14745621008776172374.stgit@firesoul>
 <CAKH8qBt-wgiFTjbNfuWXC+CNbnDbVPWuoJFO_H_=tc4e3BZGPA@mail.gmail.com>
 <d8c514c6-15bf-c2fd-11f9-23519cdc9177@linux.dev>
In-Reply-To: <d8c514c6-15bf-c2fd-11f9-23519cdc9177@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/02/2023 20.03, Martin KaFai Lau wrote:
> On 2/21/23 9:13 AM, Stanislav Fomichev wrote:
>> On Sat, Feb 18, 2023 at 7:34 AM Jesper Dangaard Brouer
>>>
>>> When driver doesn't implement a bpf_xdp_metadata kfunc the default
>>> implementation returns EOPNOTSUPP, which indicate device driver doesn't
>>> implement this kfunc.
>>>
>>> Currently many drivers also return EOPNOTSUPP when the hint isn't
>>> available. Instead change drivers to return ENODATA in these cases.
>>> There can be natural cases why a driver doesn't provide any hardware
>>> info for a specific hint, even on a frame to frame basis (e.g. PTP).
>>> Lets keep these cases as separate return codes.
> 
>> Long term probably still makes sense to export this info via 
>> xdp-features? >> Not sure how long we can 100% ensure EOPNOTSUPP vs ENODATA 
convention :-)
> 
> I am also not sure if it makes the xdp-hints adoption easier for other 
> drivers by enforcing ENODATA or what other return values a driver should 
> or should not return while EOPNOTSUPP is a more common errno to use. May 
> be the driver experts can prove me wrong here.

Which is why I suggested an errno (ENODEV) that drivers will not want to
use by accident.

> iiuc, it is for debugging if the bpf prog has been patched with the 
> driver's xdp kfunc. Others have suggested method like dumping the bpf 
> prog insn. It could also trace the driver xdp kfunc and see if it is 
> actually called. Why these won't work?

I regret talking about this as a debugging tool.  IMHO it have steered
the conversation in a wrong direction, sorry.  There are (obviously)
other metods for debugging this.

For me this is more about the API we are giving the BPF-programmer.

There can be natural cases why a driver doesn't provide any hardware
info for a specific hint.  The RX-timestamp is a good practical example,
as often only PTP packets will be timestamped by hardware.

I can write a BPF-prog that create a stats-map for counting
RX-timestamps, expecting to catch any PTP packets with timestamps.  The
problem is my stats-map cannot record the difference of EOPNOTSUPP vs
ENODATA.  Thus, the user of my RX-timestamps stats program can draw the
wrong conclusion, that there are no packets with (PTP) timestamps, when
this was actually a case of driver not implementing this.

I hope this simple stats example make is clearer that the BPF-prog can
make use of this info runtime.  It is simply a question of keeping these
cases as separate return codes. Is that too much to ask for from an API?

--Jesper

