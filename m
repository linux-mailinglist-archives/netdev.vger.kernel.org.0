Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84C6631058
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 19:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiKSS4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 13:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKSS4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 13:56:40 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FF31A054
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 10:56:38 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id x18so5642183qki.4
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 10:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lfqMHP4N4jDBBUj7vqsn/k/WGRg7Jebw1pd3PMp1kug=;
        b=p7kHqBu+xw60h0wLkzws5Dk2mFyLpwUOSiLwPOciucIOS2fGpMLLTz2VpukKSFnEWo
         rs1PI/vTuzizXZux5FHbY9d4wUGDMZCCjdeuV5DspBF1EsK1qS6JejUPhEfHA9msctcJ
         1WT9Z8kQe2IsSWZZprV2GNZiDWCBOkbu4hKPVZovjZNAiVddbxMz58/iEFxMAF2C66PR
         MX7Ur1cOxwgACr0LmiPsbj6h8B9+f4+nmY65UiWQgM6Yc+yTlWveFsITl7wk5pHnYMmL
         2szeLdBof7910dmAPC1Rn4ECVgk2vSqRukyQScV2k+enINJEauBMMEJJoErvgZif2a+D
         qwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfqMHP4N4jDBBUj7vqsn/k/WGRg7Jebw1pd3PMp1kug=;
        b=yRDMrQ4UuvDcgqZ7SeqY+saQoCPSwX/lU1OUtnAkJQfwmfoG/3GoQV4pNGWC8I80V4
         ZxIVP5hOhYk4Mq6/Bw1lZPyv3zuBGrl7SMuXhaQPntkRzm2nl7WNNqZteJtsOBr6OAD1
         GzaTD0WOFILNtop1KuZsd9WXQnlBAi8mSvqDsKhn1hLLCuQ+iepMDHsxzmG4B761LniS
         b33q/vT7Aalp+Ytd7E2UNgLAB1CLzFW6rSfC7KiS/EZxbcB17t8+bLelraDxXQbUCdl5
         MZEs5RRbr9PUwHYHQ1D1HBVN0FFRDPf3PLY2Yu+6Lrz6VjhCCZg+RcUKw8hPjCm4aGr0
         zrjw==
X-Gm-Message-State: ANoB5pn6tWa3Bq6G1w2YupeTFzYIbrj7Mq0gwkNo1mtMNkNJhoqXeCbB
        G29I66SG8jRVJIltYVN1CPxM/t9R31U=
X-Google-Smtp-Source: AA0mqf4jP+eaRGCBT4UsmZR0mpFUkJVeUquU6t+ZdHWRDZ3xh2u4Slf0XnUh1Ot8w03Yr7nk/EC/yw==
X-Received: by 2002:a37:e212:0:b0:6cd:f16e:320a with SMTP id g18-20020a37e212000000b006cdf16e320amr10803701qki.495.1668884197943;
        Sat, 19 Nov 2022 10:56:37 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:82fe:d8bd:30c3:4cf8])
        by smtp.gmail.com with ESMTPSA id i10-20020a05620a404a00b006bb8b5b79efsm5132195qko.129.2022.11.19.10.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 10:56:37 -0800 (PST)
Date:   Sat, 19 Nov 2022 10:56:36 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Christian =?iso-8859-1?Q?P=F6ssinger?= <christian@poessinger.com>
Cc:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: Re: iproute2/tc invalid JSON in v6.0.0-42-g49c63bc7 for "tc filter"
Message-ID: <Y3km5AE81dRxkWan@pop-os.localdomain>
References: <e1fa5169db254301bc3b5b766c2df76a@poessinger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1fa5169db254301bc3b5b766c2df76a@poessinger.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 05:46:09PM +0000, Christian Pössinger wrote:
> Dear Maintainers,
> 
> using revision v6.0.0-42-g49c63bc7 I noticed an invalid JSON output when invoking tc -json filter.
> 
> To reproduce the issue:
> 
> $ tc qdisc add dev eth1 handle ffff: ingress
> $ tc filter add dev eth1 parent ffff: prio 20 protocol all u32 match ip dport 22 \
>     0xffff action police conform-exceed drop/ok rate 100000 burst 15k flowid ffff:1
> 
> $ tc filter add dev eth1 parent ffff: prio 255 protocol all basic action police \
>     conform-exceed drop/ok rate 100000 burst 15k flowid ffff:3
> 
> 
> $ tc -detail -json filter show dev eth1 ingress
> [{"parent":"ffff:","protocol":"all","pref":20,"kind":"u32","chain":0},{"parent":"ffff:","protocol":"all","pref":20,"kind":"u32","chain":0,
> "options":{"fh":"800:","ht_divisor":1}},{"parent":"ffff:","protocol":"all","pref":20,"kind":"u32","chain":0,"options":{"fh":"800::800",
> "order":2048,"key_ht":"800","bkt":"0","flowid":"ffff:1","not_in_hw":true,"match":{"value":"16","mask":"ffff","offmask":"","off":20},
> "actions":[{"order":1,"kind":"police","index":1,"control_action":{"type":"drop"},"overhead":0,"linklayer":"ethernet","ref":1,"bind":1}]}},
> {"parent":"ffff:","protocol":"all","pref":255,"kind":"basic","chain":0},{"parent":"ffff:","protocol":"all","pref":255,"kind":"basic","chain":0,
> "options":{handle 0x1 flowid ffff:3 "actions":[{"order":1,"kind":"police","index":2,"control_action":{"type":"drop"},"overhead":0,"linklayer":"ethernet","ref":1,"bind":1}]}}]
> 
> 
> >>> json.loads(tmp)
> Traceback (most recent call last):
>   File "<stdin>", line 1, in <module>
>   File "/usr/lib/python3.9/json/__init__.py", line 346, in loads
>     return _default_decoder.decode(s)
>   File "/usr/lib/python3.9/json/decoder.py", line 337, in decode
>     obj, end = self.raw_decode(s, idx=_w(s, 0).end())
>   File "/usr/lib/python3.9/json/decoder.py", line 353, in raw_decode
>     obj, end = self.scan_once(s, idx)
> json.decoder.JSONDecodeError: Expecting property name enclosed in double quotes: line 1 column 698 (char 697)
> 
> This actually contains invalid JSON here
> 
> ... "options":{handle 0x1 flowid ffff:3 "actions":[{"order" ...
> 
> It should actually read:
> 
> ... "options":{"handle":"0x1","flowid":"ffff:3","actions":[{"order" ...
> 
> If you can point me to the location which could be responsible for this issue, I am happy to submit a fix to the net tree.

Please take a look at tc/f_basic.c, I don't see it supports JSON as it
still uses fprintf() to print those fields. It should be converted to
print_hex() etc..

Thanks.
