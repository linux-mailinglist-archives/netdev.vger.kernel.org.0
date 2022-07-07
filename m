Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D8756AE03
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 23:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiGGVzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 17:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiGGVzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 17:55:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1969B2E9D0
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 14:55:43 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i18so33362148lfu.8
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 14:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VjkruDOfgtNG2P/JMcjrgptBtGqklTPONWmMneNgjdQ=;
        b=e3OSeiKAf4U5yFmmwkZ2dAxTav20lD5wJSygHmb3mnxTpWLPRf52/0elcJ8FeLFhmi
         gQFBr+IzK1Mh4zYLL2TsMa4jJAoMTtzJEp/Djbh46Q2DUOgg6acWK/9ARh3VRLaWdk0n
         wdaqkoWOkrMuvyG9exWEh+M2dhFWvl9O3Vt9rB0RWAfVQADTWrJQkW1zfuuJimBh6oxO
         2F/drv67/O28bGQDl7glDEo6GEq11cNnbCenXJASchGcJUhdioC17tAc6LL7eaLvCf9W
         BmKuwNJb13KBzv3QZf0dC+R5kn9KL1DMRtUCbKdOTWQmE6fyLBBFuzPPapvHyUn8nAsO
         wrDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VjkruDOfgtNG2P/JMcjrgptBtGqklTPONWmMneNgjdQ=;
        b=2x/dt6wkdOG/9sa1sZcuzyb0ft2oj330UMe3CfNxwlv1q9VfWx5l5fj07KA/3ldxaR
         7eZl22hAJC1fxCzaJCDlWb3TFgdnVc+ViZ1KT3MHFDwIJNhzrtVYC+DpiFHTtgpWfjVg
         /LDgx8pkhYKrG+yZ7P79prTBcqs6wEBdsewbBfWZmnPL5/XQGhS1Mb0FOHSljGwKE0pz
         BxFK3gF+qpDqM4xUKDPR9jwv1G6ZC1YCEZvIdmoS8oLKMXVFC4/GDGcVIld/44JZGvHb
         N4mRL5/6ntrqgz+JHIXc5WLScEUmt9SNCEWErTMZj/MdohZOnJxRm/Q8eRKvzCd/icJ1
         5/pw==
X-Gm-Message-State: AJIora+shQeMfbKsegmy5bspVrBa0tjb8pPNqso8H30TD8O7jqf4lmyT
        op3VNxrYIJ+TLH0is34/BhTC4qmZFGPC7BNTtzKMHw==
X-Google-Smtp-Source: AGRyM1ulUqkyJL4RyJoqEjTlne97SVueY82GDwdi25+K4J351aeav1qr4l9IpBkvU0Q3fMqjGn/UQn1tge7LHhB3t4o=
X-Received: by 2002:a05:6512:3c97:b0:481:1a82:9d6b with SMTP id
 h23-20020a0565123c9700b004811a829d6bmr191230lfv.626.1657230941216; Thu, 07
 Jul 2022 14:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220702151020.2524220-1-trix@redhat.com>
In-Reply-To: <20220702151020.2524220-1-trix@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 7 Jul 2022 14:55:29 -0700
Message-ID: <CAKwvOdkeo75+BNrbH+6VHjHB_Md4VFdxy+Pgd3icxsTPCMka4g@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: return an error if setting tbl_rev fails
To:     Tom Rix <trix@redhat.com>
Cc:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, luciano.coelho@intel.com,
        ayala.barazani@intel.com, miriam.rachel.korenblit@intel.com,
        johannes.berg@intel.com, matt.chen@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 2, 2022 at 8:10 AM Tom Rix <trix@redhat.com> wrote:
>
> clang static analysis reports
> drivers/net/wireless/intel/iwlwifi/fw/acpi.c:1048:17: warning: Assigned value is garbage or undefined [core.uninitialized.Assign]
>         fwrt->ppag_ver = tbl_rev;
>                        ^ ~~~~~~~
> tbl_rev is optionaly set by a series of calls to iwl_acpi_get_wifi_pkg()
> and then jumping to the read_table when a call is successful.  The
> error case when all the call fails is not handled.  On all failed,
> the code flow falls through to the read_table label.  Add an error
> handler for the all fail case.
>
> Fixes: e8e10a37c51c ("iwlwifi: acpi: move ppag code from mvm to fw/acpi")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
> index e6d64152c81a..1ef1e26c3206 100644
> --- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
> +++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
> @@ -1044,6 +1044,9 @@ int iwl_acpi_get_ppag_table(struct iwl_fw_runtime *fwrt)
>                 goto read_table;

Thanks for the patch!

I wonder why the pre-existing code had a goto to a label that was the
subsequent statement? That's strange; maybe something was in between
them before, was removed, and that wasn't cleaned up?

I think the whole `if (!IS_ERR(wifi_pkg))` block would be clearer if this was:

...
wifi_pkg = iwl_acpi_get_wifi_pkg(fwrt->dev, data,
    ACPI_PPAG_WIFI_DATA_SIZE_V1, &tbl_rev);
if (IS_ERR(wifi_pkg) || tbl_rev != 0) {
    ret = -EINVAL;
    goto out_free;
}
num_sub_bands = IWL_NUM_SUB_BANDS_V1;
IWL_DEBUG_RADIO(fwrt, "Reading PPAG table v1 (tbl_rev=0)\n");
read_table:
...

rather than the existing spaghetti. Apologies for my formatting.

>         }
>
> +       ret = -EINVAL;
> +       goto out_free;
> +
>  read_table:
>         fwrt->ppag_ver = tbl_rev;
>         flags = &wifi_pkg->package.elements[1];
> --
> 2.27.0
>


-- 
Thanks,
~Nick Desaulniers
