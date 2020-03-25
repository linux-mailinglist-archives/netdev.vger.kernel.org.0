Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8752192F04
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYRSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgCYRSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 13:18:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 363A620772;
        Wed, 25 Mar 2020 17:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585156686;
        bh=UaoVZNRbIyDNdHgKRdy+oxNjmc75HzTFCnNcfA3yAPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zM6Vrxxox18tlNYKzygeA+H2CaFqptJkJFwVZHkbnKNUPpxwcKdrpGJmxBLHyHVgz
         C1cDGEgf7VxbtKDYkfTmXQg9vRBelWYdkBi6adtBLFYLuZf4/d351HWNgSJNKF+eR9
         iXQAcxcgKYxUgEK2ys5s+rCt7Fp+d6iOxeuJ5zFo=
Date:   Wed, 25 Mar 2020 10:18:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 08/10] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200325101804.09db32af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325164622.GZ11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
        <20200324223445.2077900-9-jacob.e.keller@intel.com>
        <20200325164622.GZ11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 17:46:22 +0100 Jiri Pirko wrote:
> >+	err = region->ops->snapshot(devlink, info->extack, &data);
> >+	if (err)
> >+		goto err_decrement_snapshot_count;
> >+
> >+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
> >+	if (err)
> >+		goto err_free_snapshot_data;
> >+
> >+	return 0;
> >+
> >+err_decrement_snapshot_count:
> >+	__devlink_snapshot_id_decrement(devlink, snapshot_id);
> >+err_free_snapshot_data:  
> 
> In devlink the error labers are named according to actions that failed.

Can we leave this to the author of the code to decide?
