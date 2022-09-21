Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30EE5BFD80
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIUMHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiIUMHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:07:33 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E49D89CC6;
        Wed, 21 Sep 2022 05:07:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x18so3508095wrm.7;
        Wed, 21 Sep 2022 05:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=0NyE71qEdo6FtKCgDXepSyI+k+crL0KCFItdssBoy3g=;
        b=NUBt3m2SlYT8+IastvZKLcpUj3pRcTbbQgI5Ak2GiSQBOgQ0CyIQXi2dlU6D9ctdC1
         HMkuhIjiDvD9G6Woao3T6oOLYFdxTGb+lTiQ24bHhrwU6QN81nnKH3oK8nw+eDltsQkj
         d6EOikWSYrOkx/WDa0vHrwTRDaHnWrNk/44YnrHmeNKDrq05d5UMXKUE1cMLs9oukIYQ
         4nWGUNPuIjPSxNR4ZlkbTtOg+5ex9LwBK9Vay6vdgJhmZjxPgV2SD8TTZvxPSx6sNm2i
         2DuxdskUpQFWTAP5OIEqgAiBao2A01HpF2NZZn1KFoQLsP954psfHGrlWV4NEh1CRaEw
         zC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0NyE71qEdo6FtKCgDXepSyI+k+crL0KCFItdssBoy3g=;
        b=Uo8hiiR6LWTBGEQqMWZWe+FyZAisC+4mGAVt2Uwaw5am2S2hcBBbGnHClFcqGezstv
         6SyWNK5I9GtT4pJwNWyg3sCcb/PjpkTGrnAgkST9BcjHr5Dt3Y3iY+zB8essAdttoK8e
         f2O8mZg2gMCIeDo9xtMnUhhWarZ16EDYrFpsR4YGPycaWzJd2bqJEyD+bpJm7pMRoGK8
         SBkZfVx636wi3wi/3NC7P/nZP5nJB5RNFe+fVNyUl+D2+4zzpoi9UXWwKNw/O1eg2w6X
         NuigUAgM95yJYuzywIysVtjFaYHmVxcdY8+JAA7XH5W4CH+6ucDp5dxQMtQxtW3DHe99
         bnIA==
X-Gm-Message-State: ACrzQf2fCysGQjQOErjARJgS3nBeAfqIjrCBnEge2feMUvffmzzVrdmI
        Ju6jlHuOyDDGjkD13ZrsaJf8U7DroPg=
X-Google-Smtp-Source: AMsMyM7I6sUAd4CF5NeoBRHWb5sPoH8qUJsfd6xLNZe0bFfh/l0BAp6IfqLQCD19idjiR5cmoFUC7Q==
X-Received: by 2002:a5d:654d:0:b0:22a:ff55:e9c9 with SMTP id z13-20020a5d654d000000b0022aff55e9c9mr8872747wrv.14.1663762050829;
        Wed, 21 Sep 2022 05:07:30 -0700 (PDT)
Received: from [192.168.8.198] (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id z6-20020a05600c220600b003b492753826sm2537354wml.43.2022.09.21.05.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 05:07:30 -0700 (PDT)
Message-ID: <33fb5be7-6c79-46d9-ddf9-92071a5271c5@gmail.com>
Date:   Wed, 21 Sep 2022 13:04:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5/5] io_uring/notif: let userspace know how effective the
 zero copy usage was
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        axboe@kernel.dk
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1663363798.git.metze@samba.org>
 <76cdd53f618e2793e1ec298c837bb17c3b9f12ee.1663363798.git.metze@samba.org>
 <5f4059ca-cec6-e44a-ac61-b9c034b1be77@gmail.com>
 <aa7d5f95-06d0-7e87-b41f-92fe07440b47@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aa7d5f95-06d0-7e87-b41f-92fe07440b47@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/22 11:24, Stefan Metzmacher wrote:
> Am 17.09.22 um 11:22 schrieb Pavel Begunkov:
>> On 9/16/22 22:36, Stefan Metzmacher wrote:
>>> The 2nd cqe for IORING_OP_SEND_ZC has IORING_CQE_F_NOTIF set in cqe->flags
>>> and it will now have the number of successful completed
>>> io_uring_tx_zerocopy_callback() callbacks in the lower 31-bits
>>> of cqe->res, the high bit (0x80000000) is set when
>>> io_uring_tx_zerocopy_callback() was called with success=false.
>>
>> It has a couple of problems, and because that "simplify uapi"
>> patch is transitional it doesn't go well with what I'm queuing
>> for 6.1, let's hold it for a while.
> 
> Once the current behavior gets released stable, we're no
> longer able to change the meaning of cqe.res.
> 
> As cqe.res == 0 would mean zero copy wasn't used at all,
> which would be the indication for userspace to avoid using SEND_ZC.
> 
> But if 6.0 would always return cqe.res = 0, there's no chance for
> userspace to have a detection strategy.
> 
> And I don't think it will cause a lot of trouble for your 6.1 stuff (assuming
> you mean your SENDMSG_ZC code), I was already having that on top
> of my test branches, the current one is:
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/io_uring-6.0.0-rc5-metze.08

Not that one though, 1) I want to shrink ubuf_info as we're a bit out
of space on the io_uring side and it prevents some embedding, so there
won't be additional fields you used. And 2) we want to have a feature
merging completion + notif CQEs into one (useful for UDP and some TCP
cases), but that would mean we'll be using cqe->res for the normal
return value.

We can disable the success counting in this case, but it's not nice,
and we can't actually count in io_uring_tx_zerocopy_callback() as in
the patch (racy). Also, the callback will be called multiple times for
a number of different reasons like io_uring flush or net splitting skbs.
The number won't be much useful and unnecessary exposes internal details,
so I think F_COPIED in cqe->flags is a better option.

It's a good question though whether we need more versatile reporting and
how to do it right. Probably should be optional and not a part of IO path,
e.g. send(MSG_PROBE) / ioctl / proc stats / etc.

> I plan to test SENDMSG_ZC with Samba next week.

Awesome

-- 
Pavel Begunkov
