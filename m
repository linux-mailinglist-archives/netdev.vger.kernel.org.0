Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6224D76F7
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 17:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiCMQtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 12:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiCMQtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 12:49:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535182E686
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 09:48:13 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id o23so11748728pgk.13
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 09:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j+ck0utZSaE8eguWP8KHHbl94tHqug0vjgSFPE+VtrU=;
        b=re4W4+sW5cFexcMJc6h5f16PyJ49EVgKPRYeWTpvVHo3zN7GZ1IsXFEvtMbi0A7jP7
         xxVMn+/s6jWPIj1VryjRP+0yLo6HI39iNMV73rBZiDOvHm+DiZr9zk7Rt9xral/v6nD7
         k4tFXM/3zwv+mitSOn3hf7PSZdIs4FP3/U7VF+L8HzXssR+WPabEZ4I/k+bNXvl8CV8t
         9Q/+bRXxiT4h8RdoClG+eiek5ALzMbCccyDXEUaWvckfyLn3y5Az9x+sFdTpDulWCQ4Z
         7R0nng7FSYy488gzfGbVFZ2pFxJvublVub4GcFjXeZHFvC9HLLlwg42CdOo/1Y/lBYrh
         rrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j+ck0utZSaE8eguWP8KHHbl94tHqug0vjgSFPE+VtrU=;
        b=BSFvjb6jD4I9XJA7aKPAw6slyoCtWBVIbvz2zZvoFuD2FMTqTM2vQ7dFcPZtVPbM2y
         w78FOwTz/fO2RcW+emDyrnVW7yos9O6A/6VXnlSAUNZHo16rrwAbfJv5KDmMPfEPhnfH
         XE4NWLTKHcKRHuirpOAY00qC/Dgi+QEpt5bu1/X7OYfCrZVQj+HUtU5CL4QhZWgvznhe
         sSYgRQUSqW8uJWEsyLLPlIIQm8HZSRHKJKPQlTmKYHEo4qVYLf+IF1jVBjgXJR2hCKCD
         D962XAR0M5cT/ue6pQrQoQoEQIbsNgjVsscNpXvVQBkyeJ9OmU29ZeccPuC9KvIpn1vL
         nMWQ==
X-Gm-Message-State: AOAM532urSUiv3WMQ/F5W0nuNm2KZ744Xj2NmM2EBSaIc8adJGcx2npW
        H2m1lzj0939jc0j5pz0dfBcJuCh1VEQFig==
X-Google-Smtp-Source: ABdhPJyh+z/yUXyWUsievGhruysmUkA7PH5M955M0I69scKsyNDKh8AExJE4c9B7NZc+NABwPaKiCg==
X-Received: by 2002:a63:db02:0:b0:381:3e21:e994 with SMTP id e2-20020a63db02000000b003813e21e994mr417986pgg.22.1647190092685;
        Sun, 13 Mar 2022 09:48:12 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l62-20020a633e41000000b0037fee1843dbsm14134493pga.25.2022.03.13.09.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 09:48:12 -0700 (PDT)
Date:   Sun, 13 Mar 2022 09:48:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>, <mst@redhat.com>, <lulu@redhat.com>,
        <parav@nvidia.com>
Subject: Re: [PATCH v6 2/4] vdpa: Allow for printing negotiated features of
 a device
Message-ID: <20220313094810.3dd7aacd@hermes.local>
In-Reply-To: <20220313124629.297014-3-elic@nvidia.com>
References: <20220313124629.297014-1-elic@nvidia.com>
        <20220313124629.297014-3-elic@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Mar 2022 14:46:27 +0200
Eli Cohen <elic@nvidia.com> wrote:

> When reading the configuration of a vdpa device, check if the
> VDPA_ATTR_DEV_NEGOTIATED_FEATURES is available. If it is, parse the
> feature bits and print a string representation of each of the feature
> bits.
> 
> We keep the strings in two different arrays. One for net device related
> devices and one for generic feature bits.
> 
> In this patch we parse only net device specific features. Support for
> other devices can be added later. If the device queried is not a net
> device, we print its bit number only.
> 
> Examples:
> 1. Standard presentation
> $ vdpa dev config show vdpa-a
> vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 2 mtu 9000
>   negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
> CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
> 
> 2. json output
> $ vdpa -j dev config show vdpa-a
> {"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false,\
> "max_vq_pairs":2,"mtu":9000,"negotiated_features":["CSUM","GUEST_CSUM",\
> "MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR",\
> "VERSION_1","ACCESS_PLATFORM"]}}}
> 
> 3. Pretty json
> $ vdpa -jp dev config show vdpa-a
> {
>     "config": {
>         "vdpa-a": {
>             "mac": "00:00:00:00:88:88",
>             "link ": "up",
>             "link_announce ": false,
>             "max_vq_pairs": 2,
>             "mtu": 9000,
>             "negotiated_features": [
> "CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ",\
> "MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
>         }
>     }
> }
> 
> Reviewed-by: Si-Wei Liu<si-wei.liu@oracle.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---

checkpatch says:

WARNING: braces {} are not necessary for any arm of this statement
#280: FILE: vdpa/vdpa.c:466:
+			if (feature_strs) {
[...]
+			} else {
[...]


