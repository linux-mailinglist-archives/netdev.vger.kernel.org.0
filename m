Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A97230888
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 13:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgG1LTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 07:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbgG1LTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 07:19:54 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C6FC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 04:19:54 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l23so816875edv.11
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 04:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gw7NL5VZYpCchNXn76sGlg2JQZMDvC04OZ0bUdR6kYk=;
        b=ImuLBPjFAxVMIJ3xqWi74z5/M5ovXzsJUiOxxAdj8raQ/3h58twmi+i4XIpZQR88bh
         Cd2hksb9lvjbTwB15EkQL4UlGUNoqMXxw/q2GW6FcHMnQ/lkEWd0M5bJw/EkU0m2JS8r
         cxQJ38sakXSQa1zN42YHkjLitEhSmuXYjBS5anN80kgfOsk/epQBcylnsFh6APefsHF0
         MVmO1aFxq4O8oV+ubm1MiLcesNi1enR9ZR1HWCViRzBmcrwd79SNEfG+FE6tn+fRs+sA
         PUvDdg/spwf2XuTjewA/pafeN4dSJCKOfSuusWh74q6V7e9nyfcH/JrkST+pa4LYi5bJ
         HneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gw7NL5VZYpCchNXn76sGlg2JQZMDvC04OZ0bUdR6kYk=;
        b=Sn4zRs4CWdmKqIf2hmV4YXLo7e9dZMBgReL2EXg4AOkRVd7KwKNfIQb+D7FRL2HAeK
         Lf9vV7QEzad69XQgV9eLoGjDquWkobE6lop7Qhge1/TYEtTk2rVKyAiIF6awbzzxG3sd
         nuiI1FKxWEQAouPJJL8m3ReW+SVyWpGq4vxlsTLZr7IlC7vL7uCsjCvRx0j1Mo00Pj+W
         ArfU/x0fXQj9ETbOvR5IXtKUeB148tgponYrzRdhzEIt65xBQhtVfcLvo55EzWriGOc4
         ZRlJQlzdAaKjZGdJcOOeSZoDO3O2B/FeW+u8gDorDWaQedIKZbuRvfvOM1A3EaM9BhJ0
         TIbQ==
X-Gm-Message-State: AOAM531NPTg6xQ/YaGWMyCXvu18VB20LQq857wFFGzPIU4u4ClhvsoP9
        mlXWkGynatdQAOuQ3SHdrMSJfw==
X-Google-Smtp-Source: ABdhPJzm2JyGxiSnlebibB7Kx7MC1pBSGpXKMWFUNvc1tkokj4BhVvdda6OpgoCu2pRMO8UKmDWJgw==
X-Received: by 2002:a05:6402:508:: with SMTP id m8mr9828949edv.279.1595935193042;
        Tue, 28 Jul 2020 04:19:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id be2sm9572043edb.92.2020.07.28.04.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 04:19:52 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:19:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
Message-ID: <20200728111950.GB2207@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200722105139.GA3154@nanopsycho>
 <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
 <20200726071606.GB2216@nanopsycho>
 <cfbed715-8b01-2f56-bc58-81c7be86b1c3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfbed715-8b01-2f56-bc58-81c7be86b1c3@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 27, 2020 at 08:13:12PM CEST, jacob.e.keller@intel.com wrote:
>
>
>On 7/26/2020 12:16 AM, Jiri Pirko wrote:
>> Wed, Jul 22, 2020 at 05:30:05PM CEST, jacob.e.keller@intel.com wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
>>>> Visible in which sense? We don't show components anywhere if I'm not
>>>> mistaken. They are currently very rarely used. Basically we just ported
>>>> it from ethtool without much thinking.
>>>>
>>>
>>> Component names are used in devlink info and displayed to end users along with versions, plus they're names passed by the user in devlink flash update. As far as documented, we shouldn't add new components without associated versions in the info report.
>> 
>> Okay. So it is loosely coupled. I think it would be nice to tight those
>> 2 togeter so it is not up to the driver how he decides to implement it.
>> 
>I felt the coupling was quite clear from Jakub's recent documentation
>improvements in the devlink-flash.rst doc file.
>
>Are you thinking find some way to tie these two lists more closely in code?

Yes. Documentation is very easy to ignore unfortunatelly. The driver
developer has to be tight up by the core code and api, I believe.

>
>Thanks,
>Jake
