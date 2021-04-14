Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC75B35F77A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350427AbhDNPSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350356AbhDNPR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:17:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA7EC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:17:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so3160511pjb.1
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZSvlQKy5gfYm/tdIVsFOBdkH2PEe0Ka5C7LOPl0nXoM=;
        b=K7cZJc1sAPFL+7rn1nNvGhfdsaa5wwzjTMy0wA8pIk1Gnh4JflohUr1sJ3cwF/u4XM
         RmyYaSTNjQqqiyI4qvY5qYlHHBDyZHKsJ2X/hQ6wXnIg9hTe4oPgUkDfs5GRnztkBL5s
         RZpTCZn25dGYZtJuNhPuJU092Kl+2DiLtq0qMbSR9WBFBIm0Mj/0MlwQjZ1fHWe3IINi
         LKgRlOTsWGcJPa3RhTjmnejUUTajfu8ccQPNRkUGmH0zKaRdyoHuXAwuvWXYMPXNJM/V
         6GGIJEKUewP/Mu3AZPnKn11MiXzICXproSWedJ7RXyfAqNH00As0/DakTDmRlJIkzoLB
         HPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZSvlQKy5gfYm/tdIVsFOBdkH2PEe0Ka5C7LOPl0nXoM=;
        b=WLJZOqyBCU5MtMrOAFjQ+1ETflZ+dhWgXc1Eu5FmTfb1MyltEAfLTtVzmv6V7kg0NZ
         2dMuSCv56n2v5hKCjQjMqBlEg5syeoXaKtaFfonsTeBO2WwzQK/NpGRsG/YArMOKBGjR
         Vm6+WHvn/p142iDmCcNoOYKnOB/r2SGhHoo+gtu/e8EL8wCackHpkCA0tjCSFwsgit/2
         dREDMQgdO9is+5Jx8US7mmhpPJWxEj/noHhoQx3mP3DtB+gVDI5by5c/rjEMLTKvpsVE
         tJVDPf3bOVFsAKWJLfQpygRbKLPzC4RapV4R6VcnzVj+HNSZVjtH7LmDj4WNMqYceg8t
         ieTw==
X-Gm-Message-State: AOAM5314V5qIP5XRfQz0OtmifJ3+gVMZloADrSD6TAhYr1uMO8qbCjt2
        SNAMAwfbj0FzF+JAfVxVKEtGgULFAIpOCQ==
X-Google-Smtp-Source: ABdhPJxhxh3RFS5O/eW7IYDnaVw7kdRpU+pz2uluPXgfJg27/n3U/XBkGfKhviOz2kb5maE5Nmf71Q==
X-Received: by 2002:a17:902:d911:b029:ea:cc53:5501 with SMTP id c17-20020a170902d911b02900eacc535501mr22262495plz.21.1618413456570;
        Wed, 14 Apr 2021 08:17:36 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id 196sm15212176pfz.82.2021.04.14.08.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:17:35 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Wed, 14 Apr 2021 18:17:28 +0300
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ruxandra.radulescu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 0/5] dpaa2-switch: add tc hardware offload on
 ingress traffic
Message-ID: <20210414151728.amjvjgnqlejrujwr@skbuf>
References: <20210413132448.4141787-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413132448.4141787-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 04:24:43PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set adds tc hardware offload on ingress traffic in
> dpaa2-switch. The cls flower and matchall classifiers are supported
> using the same ACL infrastructure supported by the dpaa2-switch.
> 
> The first patch creates a new structure to hold all the necessary
> information related to an ACL table. This structure is used in the next
> patches to create a link between each switch port and the table used.
> Multiple ports can share the same ACL table when they also share the
> ingress tc block. Also, some small changes in the priority of the
> default STP trap is done in the second patch.
> 
> The support for cls flower is added in the 3rd patch, while the 4th
> one builds on top of the infrastructure put in place and adds cls
> matchall support.
> 
> The following flow keys are supported:
>  - Ethernet: dst_mac/src_mac
>  - IPv4: dst_ip/src_ip/ip_proto/tos
>  - VLAN: vlan_id/vlan_prio/vlan_tpid/vlan_dei
>  - L4: dst_port/src_port
> 
> Each filter can support only one action from the following list:
>  - drop
>  - mirred egress redirect
>  - trap
> 
> With the last patch, we reuse the dpaa2_switch_acl_entry_add() function
> added previously instead of open-coding the install of a new ACL entry
> into the table.
> 
> Ioana Ciornei (5):
>   dpaa2-switch: create a central dpaa2_switch_acl_tbl structure
>   dpaa2-switch: install default STP trap rule with the highest priority
>   dpaa2-switch: add tc flower hardware offload on ingress traffic
>   dpaa2-switch: add tc matchall filter support
>   dpaa2-switch: reuse dpaa2_switch_acl_entry_add() for STP frames trap
>

This patch set is in the 'Accepted' state in patchwork but is nowhere to
be found in the net-next tree.

Should I do something else or it was just not pushed yet?

Ioana

