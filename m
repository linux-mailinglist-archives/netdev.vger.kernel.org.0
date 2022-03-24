Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C241B4E6444
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbiCXNpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238731AbiCXNpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:45:14 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C7F7DE14
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:43:41 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b13so2140230pfv.0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0BdbBsVUGDKfl4lbXKxzegftAQUCPpzR9cUAFXyx8Fc=;
        b=HZ0nIWpv/SZ1Cz4tmGvXpqPFr0p6oUD+UBo0KGWWlg3d+iXBUGdV1yNvwPIxFUXLqA
         Oja63mhsC2mvZ8+Cyz/LsSijgFp/6afqwnFJqwUeNUIR1IYTcE3NGD2hikJLg5CJoXEe
         bLRWRcO2/GHHwcYEcy+Kf+ETynW8qB5X+AxQAI9lwIskpb/Z6KDAFzI9BzDsecrncbFg
         s4lGSB0OZonWlAUw0Cfwh+WkAhB4uCyUp8UrkZ1jJu0+tDIWv+t86+8WyL/LuOVc+dDy
         XaN6AvJ1G7SPs6FTAIwEfYHsOkMBmzIYHGpSizdCCnt7MMRAl/lIMKz/oQxJ2yG2w52g
         FHsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0BdbBsVUGDKfl4lbXKxzegftAQUCPpzR9cUAFXyx8Fc=;
        b=iLicjuBVxy/teog7bTtctJCBBlrj+HpZLQPOU/wBrG1jF+Qj+qPOERc1hCz3TYZa6g
         q4sb2ok4WaUqBT8MWvbDuwaNodtHYb9lV5pZfR8Kg92TGeNUx474gb6VZqTHsty1dyZC
         BRw9IJG+2ZZejJ387ArfZ89bld4N3vyHYPE4L3QzNE8jcu65GKR8q4UBxaf4WaLkKcww
         4NKlAtCMcw/zBfbuhdz1k+WCIPzIzwVOymYqaiOI22/5BlCSSTuWWRRVRw1FWNJ3mLS+
         541atAj8xrEJpaRnIwbeMOq/WccCaijmKZxEgFz0a4O32li1l3HnWxvDB+fmRIFK6kPa
         BZug==
X-Gm-Message-State: AOAM532n4i6nXGDPtkENosaAboAPieK2wZokJYZjmHsTwxJj4MAr7X9F
        0GofZMAf3vnZNd9332bFHdU=
X-Google-Smtp-Source: ABdhPJxowdqO6wrcTYElP6zLb653VWFxaBGdzVNWzxKB3ZOT3YPd7DtmuldKRGjKMQdSdIAtQY8CSw==
X-Received: by 2002:a63:5847:0:b0:382:b4e:50fd with SMTP id i7-20020a635847000000b003820b4e50fdmr4200159pgm.494.1648129420606;
        Thu, 24 Mar 2022 06:43:40 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b004f40e8b3133sm3848395pfw.188.2022.03.24.06.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 06:43:40 -0700 (PDT)
Date:   Thu, 24 Mar 2022 06:43:37 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/6] ptp: Add cycles support for virtual
 clocks
Message-ID: <20220324134337.GA27824@hoboy.vegasvil.org>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322210722.6405-2-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 10:07:17PM +0100, Gerhard Engleder wrote:

> diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
> index dba6be477067..ae66376def84 100644
> --- a/drivers/ptp/ptp_private.h
> +++ b/drivers/ptp/ptp_private.h
> @@ -52,6 +52,7 @@ struct ptp_clock {
>  	int *vclock_index;
>  	struct mutex n_vclocks_mux; /* protect concurrent n_vclocks access */
>  	bool is_virtual_clock;
> +	bool cycles;

Can we please have something more descriptive?

How about a predicate like is_xyz or has_xyz or xyz_available ?

Thanks,
Richard



>  };
