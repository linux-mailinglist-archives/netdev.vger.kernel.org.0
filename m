Return-Path: <netdev+bounces-463-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C392B6F7775
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 106A01C2150B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7966BA39;
	Thu,  4 May 2023 20:51:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C73C7C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:51:49 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEE8A27D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 13:51:21 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64357904632so227048b3a.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 13:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683233426; x=1685825426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G2sMXdh2n1h9uij3Yj3dgyNdLBx+xB/0dn7Epj9aOsw=;
        b=C46YEqe5NletEbJ6jekhqCy6i4CKx8ihJEa+UQ2v3a5o/van3e56cZu/CpdHxBjG4R
         EoDbaBgVyks1nlDqggfnZ2KQEJsg563kfqFtl8kuYzSvAHuIhrqtVwBYjXdIeELJt49i
         EIZLRglPtbLshBHTfB6H6C7QtWEbQYiLjWXUKMip7p2gwdUqPeRQ+abuZ6HTWfeXX6YL
         EzJR74VeSI/p+XRD1gTUQEhXQP93iw9DhzbgikZ0aK/Ohac0LrL2Y3Qr7nFGAY05TYKJ
         baBv8RE8fqzATHqfWLtfq85+cC2QgkXS/h+QnbtZE7qfxePzb9ko5ctAq9w3X2gXGeHS
         a4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683233426; x=1685825426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2sMXdh2n1h9uij3Yj3dgyNdLBx+xB/0dn7Epj9aOsw=;
        b=SSHWpC66uupHm9QM1S7ei/dhQtC4a34kpwOLwEq9fQ+cas5PiLZ0ildYzm+B25OzKl
         +Fgy6jyRr/OD7zte5hEJaPApOgD9bPYc6H7EaSNa6v6BCYM/FpiO/63tQ5WC4rwni+aT
         zaPfXknvaxepRdvmyAMtcZ/JOcpCK5TCAdfmSWNH5NYiWE0EOM03tahiFSnOL11SdHL8
         ZYBi2zNPvHLRpuOmFE1jNJZ49H3YzbP8FsCNTNA5sKY4nDGfNXvqkbDlq+Co642ct7Pd
         kBQa2Eo9cl6MFMnjnm2huwECWTlDb0S5kOQjSKDoftPI14QNiEENWKvqlp0/wyIOSYT+
         dNpw==
X-Gm-Message-State: AC+VfDyN4Z5aib3+nLPcpRWNObm0LdAJE5uiyHfQli/mzS9gD0PXVTY2
	FtBvySQfKrccqDrgA6P3YrA=
X-Google-Smtp-Source: ACHHUZ4kF23BKU63ZCahHZR8iPcGuA3eQQ1EI8khOsxDT+svmGNoPFnwclPJJuja30fV3ZdEf1x0Ww==
X-Received: by 2002:a05:6a00:2d20:b0:63d:344c:f123 with SMTP id fa32-20020a056a002d2000b0063d344cf123mr27390064pfb.1.1683233426574;
        Thu, 04 May 2023 13:50:26 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r2-20020a655082000000b0052c22778e64sm90233pgp.66.2023.05.04.13.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 13:50:25 -0700 (PDT)
Date: Thu, 4 May 2023 13:50:23 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: "Staikov, Andrii" <andrii.staikov@intel.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky <leon@kernel.org>,
	"Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
Subject: Re: [PATCH net 1/1] i40e: fix PTP pins verification
Message-ID: <ZFQaj27FwEfXM3me@hoboy.vegasvil.org>
References: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
 <20230426071812.GK27649@unreal>
 <ZEksrgKGRAS0zbgO@hoboy.vegasvil.org>
 <f525d5b887888f6c00633d4187836da0fb31f2cf.camel@redhat.com>
 <PH0PR11MB561175B08D0E299FD1A0C127856D9@PH0PR11MB5611.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB561175B08D0E299FD1A0C127856D9@PH0PR11MB5611.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 11:12:07AM +0000, Staikov, Andrii wrote:

> Actually, the provided code snippet 
> if (pin_index >= ops->n_pins) {
>                 err = -EINVAL;
>                 break;
> }
> shows that the check happens only to the number of pins, but not their value.

The pin function from the user is checked in ptp_set_pinfunc();

> The list of the possible values is defined in the i40e_ptp_gpio_pin_state enum:
> enum i40e_ptp_gpio_pin_state {
>                 end = -2,
>                 invalid,
>                 off,
>                 in_A,
>                 in_B,
>                 out_A,
>                 out_B,
> };

Those are not passed by the user.

Thanks,
Richard

