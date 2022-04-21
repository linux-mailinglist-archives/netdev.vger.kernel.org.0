Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF5550A53C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiDUQ10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390633AbiDUQRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:17:42 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1319C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:14:51 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id m19so1996930uao.1
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 09:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TAx04H2ooTA7R83mV0WEPiN2U0g3qljg3FT+IIJR2tc=;
        b=iHLAxH0A55dhgJw3wkbgnWuIySyLwi6CXzVt7MgdAYNyb1FWLrXxXBrPicMaclLE/t
         +COAhJ383m3CO/oL692Qy4aYl/dH/+YJjjEwJftCmT5Z7x/DZtsxJ8d0W/kyC4NmupFa
         Z/FygVVk9BUixLxYcoOk1LQYXI9pX3wncRkvmfsZI/xCXBpB2f9tHr+O0TWIO1pN8h6Q
         7/pYRFa01f68Im8pyGH+pBfagHYK3Jf26vAalUhULPaa1y5tFwFy0S7H+9khHjCMBcVM
         ooF3fJNSGc1Q9DqI7FSGpYfXU4NFkOHB6NPRL3k80HOiLo8JpZZQ1Unz0USejd5HwcIQ
         UkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TAx04H2ooTA7R83mV0WEPiN2U0g3qljg3FT+IIJR2tc=;
        b=PFH3aaPzUiywhpT4HW8pVLn0kDzUJi7NLC7QaKjTjmFfOAbRmbS+cUpbul7lFuGrog
         FkVS/Mja2x+avFj0C7T/UweAYyuQoBvrYi8TD+3i/MvqAdQw06p29K8lesOyuW3IThCI
         ZwJfmwuej2PgsTQJpn2dFM98TIyArYaCYsP21BEILjElp12Fczla90V/OdsR1DifJ4Vl
         OXadj1WUKIAtfNSVkczhOOk7mFjgRPsx6TLPFTXr4u1x1Epryw/UlhO4BWxm7iJqK+FN
         OfQIWdb9aGveMX4JziE/eHh0x7wDGCumblFFrRjjXOeXWaDjkUpaDatpUeLiEfrzSNUx
         CxDw==
X-Gm-Message-State: AOAM530MD9Bri4IAU9jnBau+TsGAur+QaB0jgjJutYKmaxMfIHdih0XU
        q7QijCIi+CvxFADxemUpufq5baAHGcBBzfIrmfA=
X-Google-Smtp-Source: ABdhPJxczbVdH2vw3V2o9HxKvH0GOuNY800KQa8cJUah9vKZ2oZt+8UV7MM/g7BWWxBxWFAqoNV2lVZuDpy/saXF2Kg=
X-Received: by 2002:ab0:375b:0:b0:355:c2b3:f6c with SMTP id
 i27-20020ab0375b000000b00355c2b30f6cmr196152uat.84.1650557690817; Thu, 21 Apr
 2022 09:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
 <CAMZdPi_uieGNWyGAAywBz2Utg0iW1jGUTWzUbj3SmsZ+-iDTfQ@mail.gmail.com> <cb2f74ea-74ce-2dba-c5e3-e4672f1be663@I-love.SAKURA.ne.jp>
In-Reply-To: <cb2f74ea-74ce-2dba-c5e3-e4672f1be663@I-love.SAKURA.ne.jp>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 21 Apr 2022 19:14:40 +0300
Message-ID: <CAHNKnsQxfy0rR4wiUCsEZnf=q5HnLW4CceD99P4yPoP7PO_b=w@mail.gmail.com>
Subject: Re: [PATCH] wwan_hwsim: Avoid flush_scheduled_work() usage
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tetsuo,

On Wed, Apr 20, 2022 at 1:17 PM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> On 2022/04/20 18:53, Loic Poulain wrote:
>>> @@ -506,9 +507,15 @@ static int __init wwan_hwsim_init(void)
>>>         if (wwan_hwsim_devsnum < 0 || wwan_hwsim_devsnum > 128)
>>>                 return -EINVAL;
>>>
>>> +       wwan_wq = alloc_workqueue("wwan_wq", 0, 0);
>>> +       if (!wwan_wq)
>>> +               return -ENOMEM;
>>> +
>>>         wwan_hwsim_class = class_create(THIS_MODULE, "wwan_hwsim");
>>> -       if (IS_ERR(wwan_hwsim_class))
>>> +       if (IS_ERR(wwan_hwsim_class)) {
>>> +               destroy_workqueue(wwan_wq);
>>>                 return PTR_ERR(wwan_hwsim_class);
>>> +       }
>>>
>>>         wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
>>>         wwan_hwsim_debugfs_devcreate =
>>> @@ -524,6 +531,7 @@ static int __init wwan_hwsim_init(void)
>>>
>>>  err_clean_devs:
>
> Do you want
>
>         debugfs_remove(wwan_hwsim_debugfs_devcreate);
>
> here (as a separate patch)?

Nope. But I will not be against such a patch. I remove the "devcreate"
file in wwwan_hwsim_exit() to prevent new emulated device creation
while the workqueue flushing, which can take a sufficient time. Here
we cleanup the leftovers of the attempt to automatically create
emulated devices. Here is no workqueue flushing, so the race window is
very tight.

In other words, the preparatory debugfs file removal is practically
not required here, but it will not hurt anyone. And possibly will make
the code less questionable.

>>>         wwan_hwsim_free_devs();
>>> +       destroy_workqueue(wwan_wq);
>>>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>>>         class_destroy(wwan_hwsim_class);
>>>
>>> @@ -534,7 +542,7 @@ static void __exit wwan_hwsim_exit(void)
>>>  {
>>>         debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>>>         wwan_hwsim_free_devs();
>>> -       flush_scheduled_work();         /* Wait deletion works completion */
>>> +       destroy_workqueue(wwan_wq);             /* Wait deletion works completion */
>>
>> Wouldn't it be simpler to just remove the flush call. It Looks like
>> all ports have been removed at that point, and all works cancelled,
>> right?
>
> I guess that this flush_scheduled_work() is for waiting for schedule_work(&dev->del_work) from
> wwan_hwsim_debugfs_devdestroy_write(). That is, if wwan_hwsim_debugfs_devdestroy_write() already
> scheduled this work, wwan_hwsim_dev_del() from wwan_hwsim_dev_del_work() might be still in progress
> even after wwan_hwsim_dev_del() from wwan_hwsim_free_devs() from wwan_hwsim_exit() returned.

Exactly. This code will wait for the completion of the work that was
scheduled somewhere else.

-- 
Sergey
