Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4774D87C1
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiCNPKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiCNPKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA0F3D4A6
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:09:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9EEC61257
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34AFC340E9;
        Mon, 14 Mar 2022 15:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647270544;
        bh=px0NBcHKxXGt3qpDO6kkAyqZxg51/HsOcNeM0Xev3Fo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HajR2oZA2x31FDWGqXoOBarMz5ZtNM8IOtCEVBPb6rTBUYTlV+5BX2VzCLKbAqtHD
         eR3LdcRMfM4ctcKVrkiaUuffhVL6qzW/BGwnk5sl3/pssgt4UpgwUGCTP5YaCTOZl4
         it6IQxAvvz9sjhhRl4NzgvQXHnxTim9L8Ra1LBUy2OfBPkh+cLAn3pJNc4Pr/dIixU
         42evpQGb/Gm2vBe9kIfGVJNKqaNAUz9vKsHyPu9uPe4g55BKWIcglTHv99K9oFxNXS
         I4+C3UQF4hWBJSmtlWCs+pejCdRNFd+yE7AGreM5Ljhm74CP48qPc4D3lNtntWvyeJ
         WTO6oIbdWZpGA==
Message-ID: <6d9e4118-ee4d-0398-0db5-bd3521122734@kernel.org>
Date:   Mon, 14 Mar 2022 09:09:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v7 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com, si-wei.liu@oracle.com
Cc:     mst@redhat.com, lulu@redhat.com, parav@nvidia.com
References: <20220313171219.305089-1-elic@nvidia.com>
 <20220313171219.305089-4-elic@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220313171219.305089-4-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/22 11:12 AM, Eli Cohen wrote:
> @@ -290,6 +295,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>  
>  			NEXT_ARG_FWD();
>  			o_found |= VDPA_OPT_VDEV_MTU;
> +		} else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |= VDPA_OPT_MAX_VQP;
>  		} else {
>  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>  			return -EINVAL;

new options require an update to the man page. That should have been
included in this set. Please make sure that happens on future sets.
