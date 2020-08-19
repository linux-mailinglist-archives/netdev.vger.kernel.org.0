Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A35624A2C3
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgHSPWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHSPWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:22:38 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FFBC061757;
        Wed, 19 Aug 2020 08:22:37 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 74so11825009pfx.13;
        Wed, 19 Aug 2020 08:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b7L+0KgdWeQWWnUDBxKZIfXeQGejCvKOlPf3TPi16gY=;
        b=gwdEyD9qnxULFNboVzT+X6Uev0yvBZpOhFd530HFGQWp361vLdEJGvJYoDUM7WQqb4
         VQKa18n1RNI8zrw6Vt/7fDGokxGAwo/4e1E8dCLnXYUhhEIPIISfEnqGryqyi66kGIUa
         XA7nety1aLqiZdijkQkETEkxuP4y1waQHxDXrI4Jq9g7k0aEdV0K8r4yaJkB1ZJPhos7
         ndATu/Pib2oagKiBtkb8DGx2Spt7in7tM3i6NtRdS+OFCgZ8bINByPlRRyXg6jmWc9qp
         i5rchzFQmxvOcdo4fyDzwdqmKshGtLv/63cL2VpBkyphF81Kx+MxOgT+knxbOqDuDOZD
         ITaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b7L+0KgdWeQWWnUDBxKZIfXeQGejCvKOlPf3TPi16gY=;
        b=ShoGVti2EcT2AH3JfcqMSTF+24xiRXPwVriiff1ZD9vAhqRnaJ6jBXz2xCfD9l6RVE
         UASqJYeikWMsPyqr58aJBJthFMwYrMDXlRFt0J8Sa2FwUBMgJ/ysyKhM/wZtNc1tmBPz
         3Nmqq1iKbXNoC39iCz50GiFkZ0tmF4xy4JP17/KvtextAvF8x6z85ntUX26SyzQuO9Mr
         0kauCxbgKW8V/Sd9cumGigF1TU77ynpRkgm3+r9vxN/yfcPQlNf1gx74DkNimckFCk6g
         53LY5j1SOh0g+/9myUFtpVe/J/N+bjJjIrDc8gZ/BgUotv1HjqSH0PLf6HT8zMBwJsw3
         etQA==
X-Gm-Message-State: AOAM531Twyw66vitVN1biBacQSgxEktPhNpSdpFrNAjTyYHJ/XwGCckH
        wW2AoiRNE6p/VFnR8EXM9peU19HYkf0mXQ==
X-Google-Smtp-Source: ABdhPJwvNUDlolf2CtvfHOzsMIE0MLxrKrBQVQNmZU0mt2fHSS82vp5IYsn/11v8L80mXcrh9a+50g==
X-Received: by 2002:a63:4b10:: with SMTP id y16mr15420642pga.93.1597850557144;
        Wed, 19 Aug 2020 08:22:37 -0700 (PDT)
Received: from thinkpad (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id x136sm28149020pfc.28.2020.08.19.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 08:22:36 -0700 (PDT)
Date:   Wed, 19 Aug 2020 08:23:10 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfg80211: switch from WARN() to pr_warn() in
 is_user_regdom_saved()
Message-ID: <20200819152310.GA719949@thinkpad>
References: <20200804210546.319249-1-rkovhaev@gmail.com>
 <2893e041597524c19f45fa7e58cf92d8234893e7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2893e041597524c19f45fa7e58cf92d8234893e7.camel@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 10:46:34AM +0200, Johannes Berg wrote:
> On Tue, 2020-08-04 at 14:05 -0700, Rustam Kovhaev wrote:
> > this warning can be triggered by userspace, so it should not cause a
> > panic if panic_on_warn is set
> 
> This is incorrect, it just addresses a particular symptom. I'll make a
> proper fix.
tyvm!
