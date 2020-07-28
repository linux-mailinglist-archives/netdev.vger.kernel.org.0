Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E36231090
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbgG1RJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:09:53 -0400
Received: from mx3.wp.pl ([212.77.101.9]:37269 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731070AbgG1RJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:09:53 -0400
Received: (wp-smtpd smtp.wp.pl 15884 invoked from network); 28 Jul 2020 19:09:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1595956189; bh=XjUgdhoE66VG86SDjaFY50gdx2rDBCcdz5I3P/ow1Dk=;
          h=From:To:Cc:Subject;
          b=jMQXHMvanxAT0nudgWbdgEyByy7YAJpuBQkd+BOEOFysMAdpu6HM31hUuS0eEsdyF
           GTm4X8Q0BO6l/9mXAYDOcnpPELdGvbOCFXxOjZckUcS04mymAF8NxcaJhetQydjAZn
           YuJWNRlFonpiV+SP1BIO0h2OUCa4i8eOeHXTMfHA=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.5])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 28 Jul 2020 19:09:49 +0200
Date:   Tue, 28 Jul 2020 10:09:39 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
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
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to
 flash update
Message-ID: <20200728100939.108f33f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a41db4d7-e3f3-ecbb-0876-4ccb7da0339f@intel.com>
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
        <20200728111950.GB2207@nanopsycho>
        <a41db4d7-e3f3-ecbb-0876-4ccb7da0339f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 5c71fede71c304805e711c05e3ba7fc5
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [wUBC]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 09:58:44 -0700 Jacob Keller wrote:
> On 7/28/2020 4:19 AM, Jiri Pirko wrote:
> > Yes. Documentation is very easy to ignore unfortunatelly. The driver
> > developer has to be tight up by the core code and api, I believe.
>
> So I'm not sure what the best proposal here is. We do have a list of
> generic components, but given that each piece of HW has different
> elements, it's not always feasible to have fully generic names. Some of
> the names are driver specific.
> 
> I guess we could use some system where components are "registered" when
> loading the devlink, so that they can be verified by the stack when used
> as a parameter for flash update? Perhaps take something like the
> table-driven approach used for infos and extend that into devlink core
> so that drivers basically register a table of the components which
> includes both a function callback that gets the version string as well
> as an indication of whether that component can be updated via flash_update?
> 
> I know it would also be useful for ice to have a sort of "pre-info"
> callback that generates a context structure that is passed to each of
> the info callbacks. (that way a single up-front step could be to lookup
> the relevant information, and this is then forwarded to each of the
> formatter functions for each component).
> 
> Am I on the right track here or just over-engineering?

I don't understand why we're having this conversation.

No driver right now uses the component name.

AFAIU we agreed not to use the component name for config vs code.

So you may as well remove the component name from the devlink op and
add a todo there saying "when adding component back, make sure it's
tightly coupled to info".
