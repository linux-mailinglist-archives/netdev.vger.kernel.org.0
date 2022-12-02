Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A996402DA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiLBJDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiLBJCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:02:54 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEDC50D75
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 01:02:47 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id o13so10099884ejm.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 01:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6/2nnZFIy1WSYHGEcBnYo6P1IE1gfg1p5vr/+VFveM0=;
        b=d6DSeaBaKQwECwiLtJuK2JI2vSbVlrJAzDbyyllsOZnFwhbQBtJdBTyQyHvGyhgl/Z
         yZBaO2Yp5+EEq9i6beFCGGWvEVl0jA8JGIT4VBcqQwII7JnBl6x6JvVz1zfE2WgORW5x
         R+prmnGyG/fHKfuESN2iIpd6+da1KBxxmPCM2nU1eRPLN+XUvm2ycYy7MC0RQT3cViZs
         Q+yE9rw+lWL7t1H8OZtHyjKx88zLeRFnBYd+bTymo7h2KdSIvgtZa1J5TFT3e7JufgKq
         QeFaHOSxUNHxs/VjP8yqawmlnAkuqV1ouPCAdC4xNi0hlNTJWdalE0QSrzaTQYY+S/FP
         EOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/2nnZFIy1WSYHGEcBnYo6P1IE1gfg1p5vr/+VFveM0=;
        b=z+gealkeDiTgFc2juC6iP7/wVSNd/t9uXOpyWXm4ssJk/ikyyXlnsvTRGKTom5eSx+
         Y8Bb9M9qGwpgMZTXkFOnKmEXFqF/70HyNt4Gt5bRvsuCJuHHcnC/gwxWLx4zDxb2D80X
         qr3lsnte9WBClB84cBjesR2fed35AAWT96VMddJdIfaYLUJVxO+BW3Yg7GyvSjpFtN+z
         Mw9ti+mytmAEkszGrxRtqO6Qvymgjy+N5mJrQNR5h0Z4B7vYR0NW1mSf0l7zx9ow6SMH
         HAr9cLEMWHwAu1f9dofXArsaflO7WAZSAIg48NZ60T+kqGH1HEQMOsue9mMpelqAh2/e
         eBew==
X-Gm-Message-State: ANoB5pmIFj2EqBPSbKxtnFNkf8AvKepmyG0+qzi83ZfphyOSTtkevYvt
        Ml2LReAKESHU6kdRWAZgtZZpbg==
X-Google-Smtp-Source: AA0mqf6XIGExtJzEAEf1rOHycN57qJk2KOS+FeasMwE3OE7kvnQvGDqBmjPoABG46z9OJVIzCa6xkA==
X-Received: by 2002:a17:906:3952:b0:7b9:2a28:f6ff with SMTP id g18-20020a170906395200b007b92a28f6ffmr41123794eje.61.1669971766277;
        Fri, 02 Dec 2022 01:02:46 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e21-20020a170906315500b007bed316a6d9sm2783533eje.18.2022.12.02.01.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 01:02:45 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:02:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shay Drory <shayd@nvidia.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        danielj@nvidia.com, yishaih@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com, parav@nvidia.com
Subject: Re: [PATCH net-next V2 7/8] devlink: Expose port function commands
 to control migratable
Message-ID: <Y4m/M+jeF+CBqTyW@nanopsycho>
References: <20221202082622.57765-1-shayd@nvidia.com>
 <20221202082622.57765-8-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202082622.57765-8-shayd@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 02, 2022 at 09:26:21AM CET, shayd@nvidia.com wrote:
>Expose port function commands to enable / disable migratable
>capability, this is used to set the port function as migratable.
>
>Live migration is the process of transferring a live virtual machine
>from one physical host to another without disrupting its normal
>operation.
>
>In order for a VM to be able to perform LM, all the VM components must
>be able to perform migration. e.g.: to be migratable.
>In order for VF to be migratable, VF must be bound to VFIO driver with
>migration support.
>
>When migratable capability is enable for a function of the port, the
>device is making the necessary preparations for the function to be
>migratable, which might include disabling features which cannot be
>migrated.
>
>Example of LM with migratable function configuration:
>Set migratable of the VF's port function.
>
>$ devlink port show pci/0000:06:00.0/2
>pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
>vfnum 1
>    function:
>        hw_addr 00:00:00:00:00:00 migratable disable
>
>$ devlink port function set pci/0000:06:00.0/2 migratable enable
>
>$ devlink port show pci/0000:06:00.0/2
>pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
>vfnum 1
>    function:
>        hw_addr 00:00:00:00:00:00 migratable enable
>
>Bind VF to VFIO driver with migration support:
>$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
>$ echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:08:00.0/driver_override
>$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/bind
>
>Attach VF to the VM.
>Start the VM.
>Perform LM.
>
>Signed-off-by: Shay Drory <shayd@nvidia.com>
>Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>Reported-by: kernel test robot <lkp@intel.com>

I believe that you put reported by only to patches that fix the reported
issue which exists in-tree. It does not apply to issues found on
a submitted patch.
