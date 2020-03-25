Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4BE192A61
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCYNtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:49:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45251 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgCYNtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:49:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id t7so3107650wrw.12
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 06:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jq+YWxmnmGRn+GSSIYRdcSEhjxWIZbkS/oIiBSkn0/o=;
        b=hDDj54xqTACP7QgIm+EI/Bff5FLhdPVS6LEPIGL+RMhWCVUcdT1Z21LAf2LSP3h7KX
         so3ZkdkfoBl4YXahR8U/d4d5EprHakGKgwmdCdrB3MpzO9On8DT+yUS4Yu0jUZU4OcsR
         /rlWrp94dov6QfPoumZoJzVNPUqnK03CY32iI8gQoH8/vH3mUuBW9qge6lsp/+EJ6JDm
         up1mMdakj16/BPeFS0EbpIhrF/TQMfjDivWfc9YH/30+Z98JutaQllPYjNNoHc60dxYh
         ohtYK+xt+RtYjUYTZ5nV01ZOTdw+qNURJ7HepLFgIUbH94W7itd2npgbg3Qf7WSk8gWg
         k18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jq+YWxmnmGRn+GSSIYRdcSEhjxWIZbkS/oIiBSkn0/o=;
        b=I7TriHe0BZCujNxMbgFCjz2JTj3L46EnsTbQdzCPE7KY/yg80Melcu9QYuEwb63Np1
         gKnsH8zUzbyzdLVQFKVqS6EtElp50opbN9gTZGqxIHgk689dcD+AFqHtF4+VkzUx3/rN
         G3KZ0uUIDb1fti830NJT2TcVoEM0V4vAkPWzyCrIC69P/H7gXYJTMH6zF/s3Tl48x38d
         khCKcFsOPqqa60usnKqV4UBgefdi1xTH5sGgyoCpiW919QMO0UkTLx2Y4AP9WTeRsHeO
         PZi04GYR4fmtVUrMIKZe5MJNTQm+pDvcyMmV3ArqEeo3yapdkmm6ffVNWC8xa2LDJMUu
         xaZA==
X-Gm-Message-State: ANhLgQ2M8aSi+g3j7SXIIwUOnkhTazSaGWPEWLtGGwW4GcKGgCba/n3K
        fDc9cek2HFOJLRYFQW4tRUWGw4LQk5w=
X-Google-Smtp-Source: ADFU+vuPGMuRIB5pEV+KELGU+UwB7hy23XnXMYJx8G7azv79RN0ReiQEUEj88a/txyaYfNsPcRgIvA==
X-Received: by 2002:adf:ed86:: with SMTP id c6mr3433021wro.286.1585144169853;
        Wed, 25 Mar 2020 06:49:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f12sm9103478wmf.24.2020.03.25.06.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 06:49:29 -0700 (PDT)
Date:   Wed, 25 Mar 2020 14:49:28 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 00/10] implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200325134928.GV11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 24, 2020 at 11:34:35PM CET, jacob.e.keller@intel.com wrote:
>This series adds support for the DEVLINK_CMD_REGION_NEW operation, used to
>enable userspace requesting a snapshot of a region on demand.
>
>This can be useful to enable adding regions for a driver for which there is
>no trigger to create snapshots. By making this a core part of devlink, there
>is no need for the drivers to use a separate channel such as debugfs.
>
>The primary intent for this kind of region is to expose device information
>that might be useful for diagnostics and information gathering.
>
>The first few patches refactor regions to support a new ops structure for
>extending the available operations that regions can perform. This includes
>converting the destructor into an op from a function argument.
>
>Next, patches refactor the snapshot id allocation to use an xarray which
>tracks the number of current snapshots using a given id. This is done so
>that id lifetime can be determined, and ids can be released when no longer
>in use.
>
>Without this change, snapshot ids remain used forever, until the snapshot_id
>count rolled over UINT_MAX.
>
>Finally, code to enable the previously unused DEVLINK_CMD_REGION_NEW is
>added. This code enforces that the snapshot id is always provided, unlike
>previous revisions of this series.
>
>Finally, a patch is added to enable using this new command via the .snapshot
>callback in both netdevsim and the ice driver.
>
>For the ice driver, a new "nvm-flash" region is added, which will enable
>read access to the NVM flash contents. The intention for this is to allow
>diagnostics tools to gather information about the device. By using a
>snapshot and gathering the NVM contents all at once, the contents can be
>atomic.
>
>General changes since the v2 RFC:
>* Use an xarray instead of IDRs
>* Rebase onto net-next now that the initial ice devlink patches landed.
>
>Patch specific changes:
>* devlink: add functions to take snapshot while locked
>
>  Split this into two patches, so that an explanation of why the
>  devlink_region_snapshot_id_get is still extracted, even though only one
>  caller will remain.

It is much more convenient for reviewing purposes to have the changelog
per-patch.


>
>* devlink: track snapshot ids using an IDR and refcounts
>
>  Convert to using an xarray storing the total number of snapshots directly,
>  rather than an IDR with a refcount structure. This significantly
>  simplifies the code, and avoids the complication of a NULL refcount.
>
>* devlink: implement DEVLINK_CMD_REGION_NEW
>
>  As suggested by Jiri, remove the ability for DEVLINK_CMD_REGION_NEW to
>  dynamically generate IDs. Instead, always require a snapshot id. This
>  aligns with DEVLINK_CMD_REGION_DEL, and helps reduce confusion.
>
>  Refactor this patch to use the xarray instead of the IDR, as in the
>  previous patch.
>
>  Clean up and remove unnecessary new lines on NL_SET_ERR_MSG_MOD
>
>* ice: add a devlink region to dump shadow RAM contents
>
>  Remove the code for immediate region read, as this will be worked on in a
>  separate series following this one.
>
>Jacob Keller (10):
>  devlink: prepare to support region operations
>  devlink: convert snapshot destructor callback to region op
>  devlink: trivial: fix tab in function documentation
>  devlink: add function to take snapshot while locked
>  devlink: extract snapshot id allocation to helper function
>  devlink: convert snapshot id getter to return an error
>  devlink: track snapshot id usage count using an xarray
>  devlink: implement DEVLINK_CMD_REGION_NEW
>  netdevsim: support taking immediate snapshot via devlink
>  ice: add a devlink region for dumping NVM contents
>
> .../networking/devlink/devlink-region.rst     |   8 +
> Documentation/networking/devlink/ice.rst      |  26 ++
> drivers/net/ethernet/intel/ice/ice.h          |   2 +
> drivers/net/ethernet/intel/ice/ice_devlink.c  |  99 +++++
> drivers/net/ethernet/intel/ice/ice_devlink.h  |   3 +
> drivers/net/ethernet/intel/ice/ice_main.c     |   4 +
> drivers/net/ethernet/mellanox/mlx4/crdump.c   |  32 +-
> drivers/net/netdevsim/dev.c                   |  41 +-
> include/net/devlink.h                         |  31 +-
> net/core/devlink.c                            | 354 +++++++++++++++---
> .../drivers/net/netdevsim/devlink.sh          |  15 +
> 11 files changed, 538 insertions(+), 77 deletions(-)
>
>-- 
>2.24.1
>
