Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E84942DF3D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhJNQhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbhJNQhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:37:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B83C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 09:35:48 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso5191380pjb.1
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 09:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hFZNOi2pYipKIcrgIAAgORnMORsHTtFsnRYF+7lRJPs=;
        b=hCLfvQ49YwLXHz4QmlBPlEnWgOP5+3eOdpBY7rVjn/G+h0LECvugQadIevl5beuDoI
         BMHATibvk5FF3lMPuHS7fHp6GYq4XtkX9d575FM27if+4zvEwEtiz6AiphtdMsG5gd0a
         9UH6R23vZuGgePpF+NQlKmDslFkhF1Gx0BHcNdxYUpIGLF+ZCVcOkpWCF3LhO9dTRC9Q
         a8VwmXTqIWw4TVdw1/GU41BiHnkar6+sBddXSRgzhRk2KzvtS3EYMpto2atCfLZhEJXD
         5NJZ6qfhRa7LjoLcuyiXstFHoIDbxBjkxLzycWl2cnXD+oBLCYhSyVHz51kissA7ff1I
         ZrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hFZNOi2pYipKIcrgIAAgORnMORsHTtFsnRYF+7lRJPs=;
        b=cZKLvQKEg2nytnWccOvgblik8pJy8PwH667PSBY7FYDgxqh5Ta7mCRxbhsW3hTLZ9K
         So+bPlFRMKnOb/iuoYPn+q4HMI0fN+J+o0w/LYtSMMbC5/J26YdMjvOG+HgzLnhuhSwH
         NmGmJFNZDnhqRHI2h6PZt7WRXYkOZPgwyBsx1IQCzmbO9MZtNwTrH7Z1MwF/qqqoPhfl
         Kpp/vryOH6vbbYlWDiSmPq+oWI/GkcQjaZQoitDoKJ/A6CIdy5q584eVm0eOSQT+fOov
         ZzgI1Yv2mozRvCjNCBi8lutHzMzeuBRI9IlZLr59NgpojvPjatX4Pf++hv1ur1/hqv8M
         eqbA==
X-Gm-Message-State: AOAM531by/TXSayFL8BDzwsz5PVb3NM3+aaSooMDlVVn9Pet8+524ufX
        9tzXivbmsN35JKw+miXKWiWoomICVx8=
X-Google-Smtp-Source: ABdhPJya+kJjefffD5fPT7vY7BvugyKaWAzXsEtk1OoCxAjg1LxU0tbs3AWe1842BqQSGXDZWBUQtA==
X-Received: by 2002:a17:90a:7e82:: with SMTP id j2mr7193948pjl.165.1634229348399;
        Thu, 14 Oct 2021 09:35:48 -0700 (PDT)
Received: from [192.168.254.55] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id f30sm3078541pfq.142.2021.10.14.09.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 09:35:48 -0700 (PDT)
Message-ID: <539c6c0e373eed1cd70e4bf2f3bad75040acee6d.camel@gmail.com>
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
From:   James Prestwood <prestwoj@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Thu, 14 Oct 2021 09:32:31 -0700
In-Reply-To: <20211013164044.33178f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
         <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20211013164044.33178f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-13 at 16:40 -0700, Jakub Kicinski wrote:
> On Wed, 13 Oct 2021 16:37:14 -0700 Jakub Kicinski wrote:
> > Please make sure you run ./scripts/get_maintainers.pl on the patch
> > and add appropriate folks to CC.
> 
> Ah, and beyond that please make sure to CC wireless folks.
> The linux-wireless mailing list, Johannes, Jouni, etc.
> The question of the "real root cause" is slightly under-explained.
> Sounds like something restores carrier before the device is actually
> up.

Sure. As for the real root cause, are you talking about the AP side? As
far as the station is concerened the initial packets are making it out
after a roam. So possibly the AP is restoring carrier before it should,
and packets are getting dropped.

In v2 I'll include a cover letter with more details about the test
setup, and what was observed.


