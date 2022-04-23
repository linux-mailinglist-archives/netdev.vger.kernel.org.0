Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C2150CAD7
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiDWNzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiDWNzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:55:50 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8BB15708;
        Sat, 23 Apr 2022 06:52:52 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id e15-20020a9d63cf000000b006054e65aaecso7508810otl.0;
        Sat, 23 Apr 2022 06:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=glcKdBqRA2i6LZMNuWIeDf+vpXAFKLwX/8Rt5E789cI=;
        b=aKI7PAVjjMm2ZSI2pcfc9k7v7p3TWbHHjeK/XH9IYVwwKEkjtnDnM401eva2hYm99l
         UFxmjebyivKz1r2nk9vVfZzxW20YF5KNggnYXZAYJ8E+fJQ9BKTKHi0rjP45gVMxPAoF
         PDZHheMMiASnGzMHtHS3Xx+AGHiMqHbwedIC/wAaRnPx9ZLnZdGnyPpPjhvqzH714BBY
         uGZht11/jSdwNEH8kuavCkRjo7azLCdq+BwlKj3FbJ4GEAxKmq9xF/b1ASrGlF7/oqQt
         oLVakidSieSRIq4fdzs5pssTkezG3/jpEADZ3iYZAmFi4N/SO7bOJsceLZlMw1tG+9YG
         xJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=glcKdBqRA2i6LZMNuWIeDf+vpXAFKLwX/8Rt5E789cI=;
        b=hRGzut03o1Wbhzpivj2jFyeHTrKosc3sV2IKlmwM8MuyOAW7SJnigkWosTaxxLRQ7O
         UNZhzlmgto3O+vpj+d8gAwpiVU4ZTp/4On+yw5foZjHID3UgeR4sTLA4zdGOohIwfJKT
         u4+Yb96CN+It0ZspA2LDVHmp5bBFcCrhmcUtibCRkuY9NuK4NvIVpwRMAum4Z9sDTbiu
         flYrUarEFcS9ABcFMzHQT60dQn7qn0pwhh72bZd2Jws4gbFhan55pXXvHW+kJXEgNgM1
         4r5RrG6XnGvaW6kqBr1zxbHYDOMsda/phrWdKBzEML6aqynqVDt1O1g92M+n7YdyhaBJ
         Zdgg==
X-Gm-Message-State: AOAM5318GQYJ5GhkqOxRIKJc1wougFqbRLkvrosdGclri7VqOYB2BbOs
        PojzvubxkO71B+qi3s33pXk=
X-Google-Smtp-Source: ABdhPJz3HKRzw5ZYJnvTUBsAoDIXYpqqx2OHhzEXcRJ98gx/IZhCnSrOfDQhKSwDDbUvGF7H5cMsuQ==
X-Received: by 2002:a9d:6d8e:0:b0:5e6:bf81:f7ff with SMTP id x14-20020a9d6d8e000000b005e6bf81f7ffmr3446799otp.383.1650721971704;
        Sat, 23 Apr 2022 06:52:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o133-20020acaf08b000000b002ef7562e07csm1834027oih.41.2022.04.23.06.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 06:52:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Apr 2022 06:52:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com
Subject: Re: [PATCH v0] nfc: nci: add flush_workqueue to prevent uaf
Message-ID: <20220423135249.GA3958174@roeck-us.net>
References: <20220412160430.11581-1-linma@zju.edu.cn>
 <20220418134133.GA872670@roeck-us.net>
 <524c4fb6.6e33.1803cf85ae9.Coremail.linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524c4fb6.6e33.1803cf85ae9.Coremail.linma@zju.edu.cn>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 09:59:10PM +0800, Lin Ma wrote:
> Hello Guenter,
> 
> > I have been wondering about this and the same code further below.
> > What prevents the command timer from firing after the call to
> > flush_workqueue() ?
> > 
> > Thanks,
> > Guenter
> > 
> 
> From my understanding, once the flush_workqueue() is executed, the work that queued in
> ndev->cmd_wq will be taken the care of.
> 
> That is, once the flush_workqueue() is finished, it promises there is no executing or 
> pending nci_cmd_work() ever.
> 
> static void nci_cmd_work(struct work_struct *work)
> {
>     // ...
> 		mod_timer(&ndev->cmd_timer,
> 			  jiffies + msecs_to_jiffies(NCI_CMD_TIMEOUT));
>     // ...
> }
> 
> The command timer is still able be fired because the mod_timer() here. That is why the
> del_timer_sync() is necessary after the flush_workqueue().
> 
> One very puzzling part is that you may find out the timer queue the work again
> 
> /* NCI command timer function */
> static void nci_cmd_timer(struct timer_list *t)
> {
>     // ...
> 	queue_work(ndev->cmd_wq, &ndev->cmd_work);
> }
> 
> But I found that this is okay because there is no packets in ndev->cmd_q buffers hence 
> even there is a queued nci_cmd_work(), it simply checks the queue and returns.
> 
> That is, the old race picture as below
> 
> > Thread-1                           Thread-2
> >                                  | nci_dev_up()
> >                                  |   nci_open_device()
> >                                  |     __nci_request(nci_reset_req)
> >                                  |       nci_send_cmd
> >                                  |         queue_work(cmd_work)
> > nci_unregister_device()          |
> >   nci_close_device()             | ...
> >     del_timer_sync(cmd_timer)[1] |
> > ...                              | Worker
> > nci_free_device()                | nci_cmd_work()
> >   kfree(ndev)[3]                 |   mod_timer(cmd_timer)[2]
> 
> is impossible now because the patched flush_workqueue() make the race like below
> 
> > Thread-1                           Thread-2
> >                                  | nci_dev_up()
> >                                  |   nci_open_device()
> >                                  |     __nci_request(nci_reset_req)
> >                                  |       nci_send_cmd
> >                                  |         queue_work(cmd_work)
> > nci_unregister_device()          |
> >   nci_close_device()             | ...
> >     flush_workqueue()[patch]     | Worker
> >                                  | nci_cmd_work()
> >                                  |   mod_timer(cmd_timer)[2]
> >     // work over then return
> >     del_timer_sync(cmd_timer)[1] |
> >                                  | Timer
> >                                  | nci_cmd_timer()
> >                                  | 
> >     // timer over then return    |
> > ...                              |
> > nci_free_device()                | 
> >   kfree(ndev)[3]                 | 
> 
> 
> With above thinkings and the given fact that my POC didn't raise the UAF, I think the 
> flush_workqueue() + del_timer_sync() combination is okay to hinder this race.
> 
> Tell me if there is anything wrong.
> 

Thanks a lot for the detailed explanation and analysis.
I agree with your conclusion.

Guenter
