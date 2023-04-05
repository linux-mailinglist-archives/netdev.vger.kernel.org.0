Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450986D7B64
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbjDELcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbjDELcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:32:14 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5831701;
        Wed,  5 Apr 2023 04:32:14 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f22so30002265plr.0;
        Wed, 05 Apr 2023 04:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680694333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6/+oE/1qzPWFssmdy91t8fdNIxgaCXNVyfJtxrkUuno=;
        b=LPHPvzA1J020CPcW/uXB9oEmBOAdH98SO1O3QaxLCtkZbyzAsTMAGr5YaZSCMl1Sv4
         29XUgCecwJNKxDtrwRBYhdfwHJOEfxT16gkK0EL72JKOtssRTOG9PsnXoQyR5g5VpnxY
         BQxL1gNPKPevpom9JX1dDoWI+Dip2Tvus3WjQ1Ia2r1mhQkT0lUMXxOJK/qTMPHD1YrX
         7s56G8hzf1IrDjRAdGDC0Pu4dAu8B5SwBAmNIKLAW7q3yvbwMUKkItFKBZIpiBib7xg0
         cWL8YtGKQdj0zI0SvCfoy2oakEcJEis4Ujz7xm8R7Cq7F7xO/l0JqWW8N0NkayjMhJkl
         Wdaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680694333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/+oE/1qzPWFssmdy91t8fdNIxgaCXNVyfJtxrkUuno=;
        b=EMCPxpAm6PqyrmYfF3R++O6Qt8BL1kjJYtBn3Jkqhi+3SYJHpJ46tv0ZekSDyucKOL
         dpLlTw/pG1JgtnawzXojsUiNb5Itd4ZC609b07NrzI5FI5msy53qaTUiE0bOlPK4DGqK
         u3S1xzpqliVnvU4IZ+TdxoW+TtSTvhxA7c8o7jOhMqeo6laL87G8asQadKU/r+G5TcrT
         wUF0Tu+Y+yNKXZO4Ao9gGpuGmwEqdUrwTl6wY5TUGgpJngq1UqVl/p/STf70QzJWS9di
         5t/xu+m5qaqzt8htauccBBOk13hMLDDO2TCYQJy5CnnXczMl4JrmUC+ffDOza7i0YwA+
         IN8Q==
X-Gm-Message-State: AAQBX9eyQGI5Rd4MZJBu26XEBolcPjV+ntmxT7B1VJOCNKPUDYnAS+p/
        3h1jYvIUD18OvOCm5hfMRY0=
X-Google-Smtp-Source: AKy350aldD4O1UlZUF1oXulUPVTcaLV0KErUUZU6C2EUVJw/WIPcboaC0O4LT9MoT0yu7DNNfS59WQ==
X-Received: by 2002:a17:902:c94e:b0:1a2:79f0:f059 with SMTP id i14-20020a170902c94e00b001a279f0f059mr6989062pla.28.1680694333386;
        Wed, 05 Apr 2023 04:32:13 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902a40a00b0019aa8149cb9sm9964285plq.79.2023.04.05.04.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:32:12 -0700 (PDT)
Date:   Wed, 5 Apr 2023 20:32:09 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     edumazet@google.com, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: INFO: task hung in rfkill_unregister
Message-ID: <ZC1cObb9bAUKxdwu@dragonet>
References: <ZC1P_MSpORnZZfL_@dragonet>
 <20230405111921.853-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405111921.853-1-hdanton@sina.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 07:19:21PM +0800, Hillf Danton wrote:
> On 5 Apr 2023 19:39:56 +0900 "Dae R. Jeong" <threeearcat@gmail.com>
> > Hi,
> > 
> > We observed an issue "INFO: task hung in rfkill_unregister" during fuzzing.
> 
> Known issue [1].
> 
> [1] https://lore.kernel.org/lkml/000000000000788a6905f0c06160@google.com/

Ah, I couldn't find it in the syzbot dashboard. Thank you for letting
me know it.

> > Unfortunately, we have not found a reproducer for the crash yet. We
> > will inform you if we have any update on this crash.  Detailed crash
> > information is attached below.
> > 
> > Best regards,
> > Dae R. Jeong
> > 
> > -----
> > - Kernel version:
> > 6.2
> 
> Curious why 6.2 is preferred over upstream given waste of time looking at 6.2
> today.

I'm sorry for wasting your time. I observed the issue before, but I
had my jobs to do (kernel development is not my main job) so I
reported it now with a small hope of being helpful. I will use the
upstream kernel when I try to find bugs later.

Best regards,
Dae R. Jeong
