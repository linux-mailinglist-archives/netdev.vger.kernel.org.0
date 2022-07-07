Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2830D569FDE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiGGK2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiGGK2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:28:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D0C2F64E;
        Thu,  7 Jul 2022 03:28:41 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id y8so16804312eda.3;
        Thu, 07 Jul 2022 03:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u0grqM27ho+H910v/3h5J9J38TRWwOJg//0S3hrINWs=;
        b=RAHhsOx1WYQmtl8aJ9hOVmvAwZIviDcDLPraefIX34HzrYSnbauWDMc+Yqo+BVLdyh
         LwEkKsAOts4gLXgoy0A5iOrymg2gs/8WKzG2XOUYQacJh7ZdBXH6foa22vJkKzlvTZ5b
         +DsCgmj+L9EPE8C+/JsopzQ1mCFxOvPnxps0Y7d1C0nrdCcIuEAf4dg/bQypJGb8cboP
         HN6YdHbnv4keOK8vrE2+S4MAPTglkdBFoO7FtPj2XJc6mhCLwotN1ZXOqYPY/h1GSvUz
         GtmZo0ghamPkXVVsyRA88+po3U/bJecBzDVDnN7H2rfb83us2v18GQdwvgdqEiVjQ2e9
         C4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u0grqM27ho+H910v/3h5J9J38TRWwOJg//0S3hrINWs=;
        b=vcf6oH3j2UMlNpYjdi0LsRAHGwRm/JsblkYETOoEJSiJpvk5ftryykkzPCW8OITAjR
         KeMlBbyBI4CcuZ6bWKYQwlVIbIKWL+BPMPlHseh9X83r8toIAxy/Au6D50jWEcTl+rWc
         jD7pSLKuZpaWKFqub57T6W1i6mnboaUzd3h3GCpGVGH6V2p+hEizEAjFmsvY6eYdUlVM
         QP3lHDq5h9hr6KhVfQ0XG8Nn7bVoE2VIaMBll43WxE+A/0M04JWESqrJelZvCCHpg9h5
         22YHbtIfZ1lsSgNFniNovg4AkkYiaGIO8fpNEamSKYaYHksLaKof6igA4CfIE3VUzWL/
         S9Lw==
X-Gm-Message-State: AJIora9iEDBB469kPtS0Nx+rAy9Pffm8hmZvc7TB7IMTIyzxwQDKPjnw
        1JTLc7y5N+n15S5xqshUAa8=
X-Google-Smtp-Source: AGRyM1t2CpvNY/yKG03SEm6y8oh/fn77inxA2FFCz8Ec+X+79ad5SkuvvkcbR9VjQvnkdsn3aZ3OPA==
X-Received: by 2002:aa7:d702:0:b0:43a:5296:df67 with SMTP id t2-20020aa7d702000000b0043a5296df67mr28891799edq.314.1657189719583;
        Thu, 07 Jul 2022 03:28:39 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id f15-20020a1709062c4f00b007081282cbd8sm18701117ejh.76.2022.07.07.03.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 03:28:38 -0700 (PDT)
Date:   Thu, 7 Jul 2022 13:28:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: dsa: mv88e6xxx: allow reading FID when
 handling ATU violations
Message-ID: <20220707102836.u7ig6rr2664mcrlf@skbuf>
References: <20220706122502.1521819-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706122502.1521819-1-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 02:25:02PM +0200, Hans Schultz wrote:
> For convenience the function mv88e6xxx_g1_atu_op() has been used to read
> ATU violations, but the function has other purposes and does not enable
> the possibility to read the FID when reading ATU violations.
> 
> The FID is needed to get hold of which VID was involved in the violation,
> thus the need for future purposes to be able to read the FID.

Make no mistake, the existing code doesn't disallow reading back the FID
during an ATU Get/Clear Violation operation, and your patch isn't
"allowing" something that wasn't disallowed.

The documentation for the ATU FID register says that its contents is
ignored before the operation starts, and it contains the returned ATU
entry's FID after the operation completes.

So the change simply says: don't bother to write the ATU FID register
with zero, it doesn't matter what this contains. This is probably true,
but the patch needs to do what's written on the box.

Please note that this only even matters at all for switches with
mv88e6xxx_num_databases(chip) > 256, where MV88E6352_G1_ATU_FID is a
dedicated register which this patch avoids writing. For other switches,
the FID is embedded within MV88E6XXX_G1_ATU_CTL or MV88E6XXX_G1_ATU_OP.
So _practically_, for those switches, you are still emitting the
GET_CLR_VIOLATION ATU op with a FID of 0 whether you like it or not, and
this patch introduces a (most likely irrelevant) discrepancy between the
access methods for various switches.

Please note that this observation is relevant for your future changes to
read back the FID too. As I said here:
https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-4-schultz.hans+netdev@gmail.com/#24912482
you can't just assume that the FID lies within the MV88E6352_G1_ATU_FID
register, just look at the way it is packed within mv88e6xxx_g1_atu_op().
You'll need to unpack it in the same way.
