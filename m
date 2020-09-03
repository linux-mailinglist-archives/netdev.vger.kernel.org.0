Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F7725BAA6
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 07:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgICFym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 01:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgICFym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 01:54:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEF9C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 22:54:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a9so1569110wmm.2
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 22:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fac+qp7rSu/xEAP+vfdHYdPmveRFTAa4rjuOC/hkiHI=;
        b=Jk7VFNqkmPv3DZkKrJeNtm3h9WY8jN4adckGd5aGef7z8Qem2AMrTgH0/vFxft8Rrq
         SWB1SooS2owXXA2AJS7XeSLR8LTTkzG2jtpT3DcopFE4sgA+kqVeAuGa4YM5wlaFIxFz
         WjxEdLU9LFZP9YhWsv8H/uM4vKFPAJz6T/3yBx/hO1tjTdbRqcjsHX70k00J8CeWQhff
         QQwb9QrfpMNQxi4qj2qAKKkL9jqYfQ5Ai37C4nSDu0CEKtW/jDbSl0H7RFeH82prNQ/t
         VDI7x+R/r1VcrUFAn7GLaF3YZL01CQKqxh6moQeawUyH2/czaTLcsrXtIh8SUOSnoKU6
         r/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fac+qp7rSu/xEAP+vfdHYdPmveRFTAa4rjuOC/hkiHI=;
        b=EILIyVPDtvpxlU9T1MY1C5ZUBxK8f2vDIxYxRbdDrTlwGtlfFJ6+xZO+gben9x+nqG
         0s8BYMvOlnGLFag39CxCXghiizEUDRnFT5A+Ql1//f/dXRjeB+5gSLwpU5XbFPUsvvXw
         OtrClccwkSLKjCcOr2Oaxn51DNV/nR0uRO5+bmEqZ8gm9uZ+ZxYCFCj4dSRuvwzAIn5E
         7ta7eRQLjHQ/y3wqTxyE+a5cDWWWhkDUfWJn2JMS/O1WVi7RaWn0XLG9VG2hEQJd+W1F
         c6z6S+iPqSJ3J61x72iR4Om1X5oUnnWD/eSmWVDof1dgyRupwSUmcsyMYX/vxmwBnI+M
         Tc9Q==
X-Gm-Message-State: AOAM532gVqiThwUf/D41wGUEMJkRy+WsoXKqgvYBA1MNx8U5IDKf0dBQ
        YSM+6uTKB6rOFKe+ViLDCT+QkA==
X-Google-Smtp-Source: ABdhPJw1EYnp//IWLW0UxM+lTXJGgpTadebYAA0HW/d/bmtF6WSsJgKz3M21s+sttUGHZY367Ro63Q==
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr513669wmf.37.1599112480398;
        Wed, 02 Sep 2020 22:54:40 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 8sm2784134wrl.7.2020.09.02.22.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 22:54:39 -0700 (PDT)
Date:   Thu, 3 Sep 2020 07:54:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>, Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200903055439.GA2997@nanopsycho.orion>
References: <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901081906.GE3794@nanopsycho.orion>
 <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901091742.GF3794@nanopsycho.orion>
 <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200902080011.GI3794@nanopsycho.orion>
 <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 02, 2020 at 05:23:58PM CEST, kuba@kernel.org wrote:
>On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:
>>>> I didn't quite get the fact that you want to not show controller ID on the local
>>>> port, initially.  
>>> Mainly to not_break current users.  
>> 
>> You don't have to take it to the name, unless "external" flag is set.
>> 
>> But I don't really see the point of showing !external, cause such
>> controller number would be always 0. Jakub, why do you think it is
>> needed?
>
>It may seem reasonable for a smartNIC where there are only two
>controllers, and all you really need is that external flag. 
>
>In a general case when users are trying to figure out the topology
>not knowing which controller they are sitting at looks like a serious
>limitation.

I think we misunderstood each other. I never proposed just "external"
flag. What I propose is either:
1) ecnum attribute absent for local
   ecnum attribute absent set to 0 for external controller X
   ecnum attribute absent set to 1 for external controller Y
   ...

or:
2) ecnum attribute absent for local, external flag set to false
   ecnum attribute absent set to 0 for external controller X, external flag set to true
   ecnum attribute absent set to 1 for external controller Y, external flag set to true

>
>Example - multi-host system and you want to know which controller you
>are to run power cycle from the BMC side.
>
>We won't be able to change that because it'd change the names for you.
