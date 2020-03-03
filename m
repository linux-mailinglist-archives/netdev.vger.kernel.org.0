Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87513177325
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgCCJxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:53:06 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38746 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbgCCJxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:53:05 -0500
Received: by mail-wm1-f66.google.com with SMTP id u9so2129310wml.3
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+9ID8a3d1oK5dG7oVynjtXYqoY4Xn7Rv/V5qEYQLLvs=;
        b=cUwqnmq4shX4NCAhP1+cRkWCdkUegL27+wbohNkkj2lcjYfcMBdU/MdnpR9sfVuQDT
         3ZlLzqQwZSK7YF0JkQC6jTGQUefIq2CbzM1mBx59L23/jodmI+dMqGczPPy4E38IisKt
         O+GNtZVXYNobUmQK1bRKEUYa1uprkLf5L/sWsMxdepDsbD6d9+kKl+zX1VaUih7IkUv/
         71Sh3qyT09QZci7n1M6dOXnYQHi4Jpgkf81wM4u4gfBpemSBmdMR7HrGROJdv8nc9XFq
         nHiSJdnR6xRbBPVlNJuagt8WFUiUxYzp/mq46VFYw/iM+oh4m5HvWJ5ttYS9BgDXJspI
         E8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+9ID8a3d1oK5dG7oVynjtXYqoY4Xn7Rv/V5qEYQLLvs=;
        b=l30gKPRgqzNcx4q4JSCX+LcrT4rSX9fOUe6OVs2KvP4YSIC5bm07pY4CxvV0fpCwZj
         aV0VJUtRflPKRIdSIjAbkkdRK1uFUxnYMhXwgcXQnghjnWsraO3Qk8TMHUjX67DoJW7p
         dpv040FbY86gYqw9neRQB+6V/OXOn3mHcLO13IkKIHQVWMk//xvnocf6dFNLaD7znMqW
         5D8dezwPM0E74sOqkx0oZiOCgZmS57EX/hMryvRIr67tqlt9KE6oZh3z7p+4hhOl4m2V
         W170Z+YvffrsHJ6VUzIESf/x4Do0peMaC2s29mQ95bzaIByzAcsARbfsVGXhLk7xuFCv
         JxdA==
X-Gm-Message-State: ANhLgQ0iK/uv9T5SPm9UKjNStPBr5OvFXXsjWpUYyC2aA35ByAvk/Dzr
        Dm+KeC+etmeCCR28x9XbXphS9w==
X-Google-Smtp-Source: ADFU+vv/YWjDkvB3tyaJ9QcS37lry/EJixFv39DdIoSOsXN82SWzt1OuuGm8/UyBLax2nAbnGIdFrA==
X-Received: by 2002:a1c:5f43:: with SMTP id t64mr3466076wmb.2.1583229181947;
        Tue, 03 Mar 2020 01:53:01 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id h13sm3190369wml.45.2020.03.03.01.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:53:01 -0800 (PST)
Date:   Tue, 3 Mar 2020 10:53:00 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 11/16] team: add missing attribute validation for
 port ifindex
Message-ID: <20200303095300.GD2178@nanopsycho>
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-12-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303050526.4088735-12-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 06:05:21AM CET, kuba@kernel.org wrote:
>Add missing attribute validation for TEAM_ATTR_OPTION_PORT_IFINDEX
>to the netlink policy.
>
>Fixes: 80f7c6683fe0 ("team: add support for per-port options")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
