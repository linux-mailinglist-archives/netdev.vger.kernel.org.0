Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC106344E1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiKVTxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 14:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKVTxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:53:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056117DEFA
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F35E4B81B35
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72FC433D6;
        Tue, 22 Nov 2022 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669146795;
        bh=spWl5BtmrE3zsFL67TKAaVL+0+O8lrljouSW9C9KWQo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QD3yLaJkc9QtNVk2UEfCVO2zCO8vcoDZPhBTawQObxjem2MJIjsvj8Birsdgpa9uv
         7SRx9/YNgmvFRRmcod0Qgvd2xbakUl3TF1JhoTb6HyF0SUU4J0v/DO3yxkiE+35tKR
         MVdoRUWGNza67ZI46NPIB5SfBT3u3VgNsULV/jP2Va45NY7UPWM0Es3SqUKqhOzj2o
         fxw0nK3C7dLYtyBM/jbe2BSDa5tLxn147oqcE6Is8iy5YiMcZFxJSO6VhG/opJSZmC
         dwnLo74GiE+n+FewOqkxapP2rLjSURYRSs5lpyhBzL4OqEPz/itHCkTqMdOJTx8/Hi
         4GnQxiJrBK+vw==
Message-ID: <f9b35219-ba26-1251-5c78-d96ac91b0995@kernel.org>
Date:   Tue, 22 Nov 2022 11:53:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, si-wei.liu@oracle.com,
        mst@redhat.com, eperezma@redhat.com, lingshan.zhu@intel.com,
        elic@nvidia.com
References: <20221117033303.16870-1-jasowang@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221117033303.16870-1-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 8:33 PM, Jason Wang wrote:
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index 94e4dad1..7c961991 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -51,6 +51,7 @@ enum vdpa_attr {
>  	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>  	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
>  	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> +	VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>  
>  	/* new attributes must be added above here */
>  	VDPA_ATTR_MAX,

this header file already has:
	...
        VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
        VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
        VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */

        VDPA_ATTR_DEV_FEATURES,                 /* u64 */

        /* virtio features that are supported by the vDPA device */
        VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */

        /* new attributes must be added above here */
        VDPA_ATTR_MAX,

in which case your diff is not needed. More importantly it raises
questions about the status of the uapi file (is it correct as is or is
an update needed) and which tree you are creating patches against?

> @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
>  static void cmd_dev_help(void)
>  {
>  	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> -	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> -	fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
> +	fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");

lost the space between mgmtdev and MANAGEMENTDEV


> +	fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
> +	fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
>  	fprintf(stderr, "       vdpa dev del DEV\n");
>  	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
>  	fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");

