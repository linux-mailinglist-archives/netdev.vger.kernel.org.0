Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB4D149E79
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 05:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgA0EDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 23:03:19 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:36325 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgA0EDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 23:03:18 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so6369554iln.3
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 20:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zmAgkN6gBrhJ3tPU0oV2PyU6BWpEwi4U41T62RRUzjA=;
        b=VH9OPXAK+slCyzTbgdy1t3WsJNFIWol2/LkeB4xgnyVdsSYBGxd5sRRHQ4vae6Xn82
         H3CfMy2rXRJYs0eMiF9DqU0mAqaOaMp3wybGMblWozr6qAn/6ijJ+K8E6DgS1+BnzAY7
         wPalu5/TlzgBUXXdr6nuPPckYvXRE0kQ5bMo8uQNgYqDvIozD77qGVqZT7Cvjfk9wbwA
         b4K47uXN6wiEBG1xgUR9nKKlhRclKSWe/nnbaPiOzKHOs8anJIpm8yj5hzJOcpeTn7U7
         W/TNLzY4P138UaIne7YYg4bDFN+1dwdnxol11/I45lrJrNTnQkycuv0h2QlbPtIeJH0u
         jRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zmAgkN6gBrhJ3tPU0oV2PyU6BWpEwi4U41T62RRUzjA=;
        b=LiB7LGvxgfgdRr9fY7YZPIWyWg0i5Pwa/KAD30DKD1iVIeSLnKCNO/+TQrbRQktlm9
         3EwMw/NE/f8+Fs10fDDwu+TlSTY6CkpFIOQcqOjam6XWx+hgubvD8MoiECsL/968Ici/
         zt7pVieIFszM1qacbCjt8SZVpv4uRCdzqxtTX0yv55nceRTDIllvhACsu1TNv4UubpvY
         voQlf2ZRDniF82LOMOgGBaBttL/dpSGgBuAqpKmbBKGdkmqNJrgeXSEtTAmzcOC3VJH8
         mqfRzKLeUuy8jojb5QbF4Z2tr1ldeJRIJsRBPU4RR+y6iKzo3HdhqmnjEIU9qQLp4hlx
         IUIQ==
X-Gm-Message-State: APjAAAUgXTvoOpnR67AxvmDigSPpaodj1gXdnQIDPg/biq9dM/Q0mDLt
        RJ3tbN3ZwhPBZi+K3IjlHu4=
X-Google-Smtp-Source: APXvYqznOLAN6rIUZXDpW3NBfjd8zQgdA61F6D55wL0jqewuFYdSkCG75I5TEu7cNqoeytrDBMp62Q==
X-Received: by 2002:a92:cc89:: with SMTP id x9mr13853325ilo.77.1580097797992;
        Sun, 26 Jan 2020 20:03:17 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:58fc:9ee4:d099:9314? ([2601:282:803:7700:58fc:9ee4:d099:9314])
        by smtp.googlemail.com with ESMTPSA id e7sm3159513ios.47.2020.01.26.20.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 20:03:17 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126141141.0b773aba@cakuba>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
Date:   Sun, 26 Jan 2020 21:03:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126141141.0b773aba@cakuba>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 3:11 PM, Jakub Kicinski wrote:
> 
> I looked through the commit message and the cover letter again, and you
> never explain why you need the egress hook. Could you please clarify
> your needs? 

XDP is about efficient network processing - ie., bypassing the Linux
stack when it does not make sense for the person deploying some
solution. XDP right now is Rx centric.

I want to run an ebpf program in the Tx path of the NIC regardless of
how the packet arrived at the device -- as an skb or an xdp_frame. There
are options for running programs on skb-based packets (e.g., tc). There
are *zero* options for manipulating/controlling/denying xdp_frames -
e.g., one REDIRECTED from an ingress device.

