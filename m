Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E509665764
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbjAKJ14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbjAKJ1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:27:01 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397B5BE29
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:26:20 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so19389175pjq.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jSxVNzqlzAA9BL4Ue5CY5G4v2f26qUB7RszYgPgB6/o=;
        b=rADxOXF4EEGJIlqxWGVgECMo6q7YKavJfMHFJ/USSJKekr88ebOEyPXX/jZ1kaD4u0
         EbkMvxh0RtEQ6xDnTMlh3iB/rmyXdcmSJxNxYcQKWiwb99YILhZvlQKKu6dk3UvYiZLq
         I0y6XUwY7K5T8TR79raiwUeUk+puvxLk5M05DiCy0rz0TkTbnE9ehVcTOYRPGVD/CIT7
         0mFsk5RXIM3Xvx/xdI/BqJi6450TsftYsHV0d4qyf9KPAftDTQj3JqkGBqiavja0j00a
         HRRad8BnrjT++vyOxa6JPYjWNCttTCB/jjJ87Xlb9+rBMGFxQ3f5UnNiPnvNn6DXxxlr
         cNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSxVNzqlzAA9BL4Ue5CY5G4v2f26qUB7RszYgPgB6/o=;
        b=NxQkTy4VQQcHz8y56AcRbHhB10QMNLcT6tJdu9h+jcpRnO5ApvXK9TkXvWAXpgdboL
         zBBZfU1lCTqY9csYmM6tUASH4kuewLBSvE5xNwepZsqs5rzUllnV1kiDCHaj51ASGBQp
         Tg65kTa94JmK0tDoRzz2rdyVU0xkgY1Vo42SED/U0JalhiqD3QV2fOgPRC2lS+VSbM/W
         AkGL1zVyG+4C0jquthSkP1jE+kjK25wufpEezm6KHAJ/8iBDga5vq+lBFUgiTcaZlJe+
         ip1GqDEGr8h09RsHQXQEL7mwcoxsR9eCxPg+IbFtcP3Pzj7243VEXeZuY6oV3MjGBV21
         pyJQ==
X-Gm-Message-State: AFqh2koYuUJzvv2J48/XMhJudgzYE77f/ZjAhHH6R5rAuzVpmRV4iJ8v
        UiI/iT5DwIdwaLEO04lqmXBOdg==
X-Google-Smtp-Source: AMrXdXtMBFoJEdrN3emyvzysbEsBicIWQfSKPfOIYFgtdMSeqingNUjRlvyRx2mRUFk62kSb2TlQSg==
X-Received: by 2002:a05:6a20:429f:b0:a4:aa40:2260 with SMTP id o31-20020a056a20429f00b000a4aa402260mr2432593pzj.60.1673429179591;
        Wed, 11 Jan 2023 01:26:19 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b00186985198a4sm9638597plh.169.2023.01.11.01.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:26:19 -0800 (PST)
Date:   Wed, 11 Jan 2023 10:26:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com,
        syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] devlink: keep the instance mutex alive until
 references are gone
Message-ID: <Y76AuAgS5agEvNpe@nanopsycho>
References: <20230111042908.988199-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111042908.988199-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 11, 2023 at 05:29:08AM CET, kuba@kernel.org wrote:
>The reference needs to keep the instance memory around, but also
>the instance lock must remain valid. Users will take the lock,
>check registration status and release the lock. mutex_destroy()
>etc. belong in the same place as the freeing of the memory.
>
>Unfortunately lockdep_unregister_key() sleeps so we need
>to switch the an rcu_work.
>
>Note that the problem is a bit hard to repro, because
>devlink_pernet_pre_exit() iterates over registered instances.
>AFAIU the instances must get devlink_free()d concurrently with
>the namespace getting deleted for the problem to occur.
>
>Reported-by: syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
>Fixes: 9053637e0da7 ("devlink: remove the registration guarantee of references")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reported-by: syzbot+9f0dd863b87113935acf@syzkaller.appspotmail.com
