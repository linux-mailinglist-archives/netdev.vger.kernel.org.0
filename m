Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BF4194409
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 17:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgCZQJq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 12:09:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:30653 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbgCZQJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 12:09:46 -0400
IronPort-SDR: /x788yRyPpKmwMm+iXHS9KASkh6BH6+2XVEFkR71IODONBZFxQHVP81GhV71iuJro0daPaEc7c
 2seyWjgPEXRg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:09:45 -0700
IronPort-SDR: jaYcGdn61xp/hhx4RqEMo8wU7C7K3/Dted5QbyFNwvH8dEQNKL3DiX7Qw118WEgNo0G9zd2o3Y
 /To6zdo9P7Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="447063075"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga005.fm.intel.com with ESMTP; 26 Mar 2020 09:09:45 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 09:09:45 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.121]) by
 fmsmsx124.amr.corp.intel.com ([169.254.8.220]) with mapi id 14.03.0439.000;
 Thu, 26 Mar 2020 09:09:45 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next v2 07/11] devlink: report error once U32_MAX snapshot
 ids have been used
Thread-Topic: [net-next v2 07/11] devlink: report error once U32_MAX
 snapshot ids have been used
Thread-Index: AQHWAyH0T4xSIo9bakaH3DJ4806VUKha8AOAgAAbI7A=
Date:   Thu, 26 Mar 2020 16:09:44 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B6CA3E5E@fmsmsx101.amr.corp.intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-8-jacob.e.keller@intel.com>
 <20200326073047.GJ11304@nanopsycho.orion>
In-Reply-To: <20200326073047.GJ11304@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jiri Pirko
> Sent: Thursday, March 26, 2020 12:31 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [net-next v2 07/11] devlink: report error once U32_MAX snapshot
> ids have been used
> 
> Thu, Mar 26, 2020 at 04:51:53AM CET, jacob.e.keller@intel.com wrote:
> >The devlink_snapshot_id_get() function returns a snapshot id. The
> >snapshot id is a u32, so there is no way to indicate an error code.
> >
> >Indeed, the two current callers of devlink_snapshot_id_get() assume that
> >a negative value is an error.
> 
> I don't see they do.
> 

You're right, they don't. I was confused when I wrote this because the previous version of this patch did change them to check for error, and then I realized we didn't need that patch and removed it, but forgot to update this.

Can fix this if we need a respin for another reason.

> 
> >
> >A future change is going to possibly add additional cases where this
> >function could fail. Refactor the function to return the snapshot id in
> >an argument, so that it can return zero or an error value.
> >
> >This ensures that snapshot ids cannot be confused with error values, and
> >aids in the future refactor of snapshot id allocation management.
> >
> >Because there is no current way to release previously used snapshot ids,
> >add a simple check ensuring that an error is reported in case the
> >snapshot_id would over flow.
> >
> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> The code looks good.
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
