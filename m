Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7300968BD0B
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 13:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjBFMiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 07:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjBFMiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 07:38:07 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69CFAD11;
        Mon,  6 Feb 2023 04:38:05 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id n28-20020a05600c3b9c00b003ddca7a2bcbso8660735wms.3;
        Mon, 06 Feb 2023 04:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nl1ef4jLjUcFGNJSIU9f42mjt7HPlVJsc4PI7PrwoAk=;
        b=j0OJtxiyD76szXH0TQyzAmQXjnANVo0QfoggDq0r2EO/JC2sXbYLg2hLx39moAXS6A
         tVFYfXFHP5fAKtuEpVvSYFIkcOVOMIUy0G5kntIiwdRNOdnpjBQHdtiZyvUig0Wm1QnL
         nzwqFhNAjpv79B7wgS66rFitMQdB313gO8u9L+D14xsmhF2dzeHWIAb17I5ix1o4Rt46
         WrUyKSWQTjHHBVnWwLjMHnQJ525Bjw1wKjgj+FBrI3prZm9zRqFA8pQO7q7abIZ/wWN1
         kJMfhGZ3fbJ9JBlj6K34A2KUvSl6CI4anQuVwcThHRwEKSEnOQNWz12ZWxWpg9MT4fFp
         J6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nl1ef4jLjUcFGNJSIU9f42mjt7HPlVJsc4PI7PrwoAk=;
        b=yI/W9qpb/WwHqRr0b4Li6FfIQiKZinGqWpOKmh7PsV5RIni3M8fGDfgzevhUXaZtyK
         x7abPfbWcGMydwhIAtH8luN0XVV8EX/fUFjx8pROjrjAtAL2GhFSE4GxlfnnGQZMkIa6
         9mlN+lTLtpi30PyJLNP58HEkk5RSU9wy7Qt7gGM1DWyRr62+jKO3hcCqmHMFiY74nGpc
         vJ/WXN2TIYYyJmXxwd/Wl7mGwj8kHytmALK75wjaG7V8fC3DQmH7jNVpS4/m8rdVBysG
         VBp7EOsn8dahd6BNhu1vSV8yY6puIsZdVzn3ZhyrXVujLMzDIHBmzx9DgM5aLzgpsw+w
         GdaQ==
X-Gm-Message-State: AO0yUKWZqoS4C3sqTKKbAT2O9iT4PzitrzZE/mWp+curWEPiNIERvJKn
        /E8JlMFRJg7zieKXP9RzV0A=
X-Google-Smtp-Source: AK7set81zsVCjpAq5G9nVyQetaO54svw7cTKFUb58lUY3lYWNsvYcR1XCpkUPMp20vE5adm+LLAl2A==
X-Received: by 2002:a7b:ca5a:0:b0:3de:db64:a56f with SMTP id m26-20020a7bca5a000000b003dedb64a56fmr923933wml.13.1675687084499;
        Mon, 06 Feb 2023 04:38:04 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t1-20020a1c7701000000b003b47b80cec3sm15664406wmi.42.2023.02.06.04.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:38:04 -0800 (PST)
Subject: Re: [PATCH v5 net-next 3/8] sfc: enumerate mports in ef100
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-4-alejandro.lucero-palau@amd.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <fc2d452c-fa7f-39bb-b8bc-08e07ee9fbbc@gmail.com>
Date:   Mon, 6 Feb 2023 12:38:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230202111423.56831-4-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 11:14, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> MAE ports (mports) are the ports on the EF100 embedded switch such
> as networking PCIe functions, the physical port, and potentially
> others.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
...
> +struct mae_mport_desc {
> +	u32 mport_id;
> +	u32 flags;
> +	u32 caller_flags; /* enum mae_mport_desc_caller_flags */
> +	u32 mport_type; /* MAE_MPORT_DESC_MPORT_TYPE_* */
> +	union {
> +		u32 port_idx; /* for mport_type == NET_PORT */
> +		u32 alias_mport_id; /* for mport_type == ALIAS */
> +		struct { /* for mport_type == VNIC */
> +			u32 vnic_client_type; /* MAE_MPORT_DESC_VNIC_CLIENT_TYPE_* */
> +			u32 interface_idx;
> +			u16 pf_idx;
> +			u16 vf_idx;
> +		};
> +	};
> +	struct rhash_head linkage;
> +	struct efx_rep *efv;

Looks like this isn't used or populated anywhere, so probably
 shouldn't be added yet.
Apart from that, LGTM.
