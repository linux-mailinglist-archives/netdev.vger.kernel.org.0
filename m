Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691D1194A55
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgCZVQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:16:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50675 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbgCZVQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:16:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id d198so8769547wmd.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pKznpSVE3tkqj7JL1cn31Ne8FbhVUi5I3m3zDdIuy9M=;
        b=evXq9i3ufBt8ZKNlN1iBF/UOR3EEgpWktss6Txq8/ySBpNFChN+4A+RZzAShaYJvFO
         U1Gvum7XXVirJ5gDz/b8Lmu2vbsGLzxMg0AYNvTk1U+JyVISyxCVnh3/gw9/4e7pmxnr
         a5hKm3MuesqH4b2+O5DPo3hr/PemTPGrGvgM9fedWMY6VQNwNny0wDwAF92twK3qEU6c
         Js82BGGyHia+KQte8Zsgabshnxc5o/pVwdBJYc1cafw2+4tUP0gC/8d4XqVYHlQy2klr
         hOx5ICTGW92p3ae/2d4enGIw0qYMsxffDVhBZ7ljpw/74/nJcP1hv4dK0Z3K1eX79oD+
         Fm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pKznpSVE3tkqj7JL1cn31Ne8FbhVUi5I3m3zDdIuy9M=;
        b=NU2YRTVwdTr987zDnOiUjUzmiWaWik+nc7PUp1AatMtmstBEX8V06ConBBMu+osuKY
         XsMuqhv9zuwlNY1XNduRRofHoKeC5WTEvidzfmXOoovIQTb+KzEZhh1J7zxUSlSmMrRr
         tfR7DcveMo8J4hHHXj+t8q+cdlRDgvHlIeYL7lEdC4UMxBoflN5IvTFFzhFUU1YAtZ1z
         3xC9t5XXxh+FULV5xhd/ZwEExa6aQLGXMjIUzgdVgEDlsk6RnV8Ta3UOpcF8Vl/8xBw+
         fq7u8RY4YOn2SYFeZ8MkzrDxdkSvlI9suwH586IZsbK4e8CRRGEzjoeHkI03VhOVqmjE
         xEPw==
X-Gm-Message-State: ANhLgQ2EF2pN4rvazOogNoOWL1RdkVG5ah5zhsrgtU87NRBSGi+TkiUO
        BBoOwTvz36mPntUf1O1+dWU73g==
X-Google-Smtp-Source: ADFU+vsFrh3aNOyquIuD3jXao9GMMFgWRcPdWoay1reBfRZgB7UsJki1HqMGzNtGtpcn4FjjGSVVOg==
X-Received: by 2002:adf:eb48:: with SMTP id u8mr11183522wrn.283.1585257414473;
        Thu, 26 Mar 2020 14:16:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a186sm5045448wmh.33.2020.03.26.14.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:16:54 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:16:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 08/11] devlink: track snapshot id usage count
 using an xarray
Message-ID: <20200326211653.GE11304@nanopsycho.orion>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-9-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326183718.2384349-9-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 07:37:15PM CET, jacob.e.keller@intel.com wrote:
>Each snapshot created for a devlink region must have an id. These ids
>are supposed to be unique per "event" that caused the snapshot to be
>created. Drivers call devlink_region_snapshot_id_get to obtain a new id
>to use for a new event trigger. The id values are tracked per devlink,
>so that the same id number can be used if a triggering event creates
>multiple snapshots on different regions.
>
>There is no mechanism for snapshot ids to ever be reused. Introduce an
>xarray to store the count of how many snapshots are using a given id,
>replacing the snapshot_id field previously used for picking the next id.
>
>The devlink_region_snapshot_id_get() function will use xa_alloc to
>insert an initial value of 1 value at an available slot between 0 and
>U32_MAX.
>
>The new __devlink_snapshot_id_increment() and
>__devlink_snapshot_id_decrement() functions will be used to track how
>many snapshots currently use an id.
>
>Drivers must now call devlink_snapshot_id_put() in order to release
>their reference of the snapshot id after adding region snapshots.
>
>By tracking the total number of snapshots using a given id, it is
>possible for the decrement() function to erase the id from the xarray
>when it is not in use.
>
>With this method, a snapshot id can become reused again once all
>snapshots that referred to it have been deleted via
>DEVLINK_CMD_REGION_DEL, and the driver has finished adding snapshots.
>
>This work also paves the way to introduce a mechanism for userspace to
>request a snapshot.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
