Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175A62CDDE5
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgLCSlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgLCSlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:41:04 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE40C061A4F;
        Thu,  3 Dec 2020 10:40:18 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t37so1934741pga.7;
        Thu, 03 Dec 2020 10:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W5vDV9iOP31Wm581raHT9lC6nNCaICsVygVFILGkqlU=;
        b=ZNiThM9wtUopnYYeU5vnsAwWOLKHFITA1p6OBSrZwNxYK9e9SzRLsHviwxQBun0lsg
         STNe4DervsrNNJw1dlg+y7MzaytFXajBZoMSDWTkH5AX5mUkTzHqeyLsRd5VacJYn+vy
         4ijFBCiXoLnrBAIg7pSOAfwgeVYnbDASZU5rzqNIgyn+TiU2io8nqfMigrsRjVweRuBk
         tCkDv3bNcnbl4DtpNusrVoBTpFBmmAfc4Jqbv1xf+YMWhUQJ1/86/6gYyc0yQxF++JtS
         cCUoKElUuZdgVCMhjLlYpobxXx/K/ute0tHcuv2veBlWCbOXoptwXeeay9d1+PSrVWVX
         mNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W5vDV9iOP31Wm581raHT9lC6nNCaICsVygVFILGkqlU=;
        b=JL3WcqSmXTJBJ8FyMmWQWQavIXcoxwbibSaVS/D2/9JWmMzzWNWVkiyMBsPAPBRdQ/
         tF04V6qEMyeu0JOAIUOdRepE1xlwW7oqxnfoEjhkkgQWlYNI7oTZo7xSXvGHZLAvl72J
         B03hNzu3WBDrQZc/njkHcLFyY4rUmmm7t+MPSPVHo3N2JOV69SbvqmCU18hSAbnxqc3F
         VfJ4tn1q8na182k6zO5x8V7Z9Nh2kiTrocH0vZDZ00Bm6Xc/ggwxobZPtTEnyboDhS3v
         5nEtpi1d/w7cpzgdexKix78mW+cZJeKmAkr/EBgjuf2oF/AEFmVDUKIW5jmKR+9yb1M0
         kFxw==
X-Gm-Message-State: AOAM5333bgsVpggTlItWxLtO4oJVLthQVudduQRMw/TqoPjk7RHGO5+y
        7+dQYHeLmNbXgJI7uJUiqvk=
X-Google-Smtp-Source: ABdhPJwhBqVIOPfAG1Z9q3dYb0G1X+vzjOYL5a98hLGTsMKYRA+PjHEVCeDbtR8Fdsoj2pNMpLRKeQ==
X-Received: by 2002:a63:181b:: with SMTP id y27mr4191123pgl.408.1607020818122;
        Thu, 03 Dec 2020 10:40:18 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:a629])
        by smtp.gmail.com with ESMTPSA id m9sm2469683pfh.94.2020.12.03.10.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 10:40:17 -0800 (PST)
Date:   Thu, 3 Dec 2020 10:40:14 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     mariusz.dudek@gmail.com
Cc:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: Re: [PATCH v7 bpf-next 0/2] libbpf: add support for
 privileged/unprivileged control separation
Message-ID: <20201203184014.fcayxrqusi6aptje@ast-mbp>
References: <20201203090546.11976-1-mariuszx.dudek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203090546.11976-1-mariuszx.dudek@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:05:44AM +0100, mariusz.dudek@gmail.com wrote:
> From: Mariusz Dudek <mariuszx.dudek@intel.com>
> 
> This patch series adds support for separation of eBPF program
> load and xsk socket creation. In for example a Kubernetes
> environment you can have an AF_XDP CNI or daemonset that is 
> responsible for launching pods that execute an application 
> using AF_XDP sockets. It is desirable that the pod runs with
> as low privileges as possible, CAP_NET_RAW in this case, 
> and that all operations that require privileges are contained
> in the CNI or daemonset.
> 	
> In this case, you have to be able separate ePBF program load from
> xsk socket creation.
> 
> Currently, this will not work with the xsk_socket__create APIs
> because you need to have CAP_NET_ADMIN privileges to load eBPF
> program and CAP_SYS_ADMIN privileges to create update xsk_bpf_maps.
> To be exact xsk_set_bpf_maps does not need those privileges but
> it takes the prog_fd and xsks_map_fd and those are known only to
> process that was loading eBPF program. The api bpf_prog_get_fd_by_id
> that looks up the fd of the prog using an prog_id and
> bpf_map_get_fd_by_id that looks for xsks_map_fd usinb map_id both
> requires CAP_SYS_ADMIN.
> 
> With this patch, the pod can be run with CAP_NET_RAW capability
> only. In case your umem is larger or equal process limit for
> MEMLOCK you need either increase the limit or CAP_IPC_LOCK capability. 
> Without this patch in case of insufficient rights ENOPERM is
> returned by xsk_socket__create.
> 
> To resolve this privileges issue two new APIs are introduced:
> - xsk_setup_xdp_prog - loads the built in XDP program. It can
> also return xsks_map_fd which is needed by unprivileged
> process to update xsks_map with AF_XDP socket "fd"
> - xsk_sokcet__update_xskmap - inserts an AF_XDP socket into an
> xskmap for a particular xsk_socket
> 
> Usage example:
> int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)
> 
> int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);
> 
> Inserts AF_XDP socket "fd" into the xskmap.
> 
> The first patch introduces the new APIs. The second patch provides
> a new sample applications working as control and modification to
> existing xdpsock application to work with less privileges.
> 
> This patch set is based on bpf-next commit 97306be45fbe
> (Merge branch 'switch to memcg-based memory accounting')
> 
> Since v6
> - rebase on 97306be45fbe to resolve RLIMIT conflicts

Applied, Thanks
