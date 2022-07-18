Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CCB578C46
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 22:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiGRU62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 16:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiGRU6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 16:58:20 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65EF32B91
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 13:58:18 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 19so15148908ljz.4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 13:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MiQ+xQxx8hd0dlOeoQTIZgHydZebknID1GX7TXEZwqY=;
        b=UXe8Cf2JLOSGbf9v+WHy5ow7tsX4GzUvDFhUAw4qsj86k+3sd8z+PTBhrJqCT64GOB
         vlJP5xyX+3SnkFvEPX7q2tjxrYwW7oPoKSwe03WAxTwyuxLVNewsJlodCViVgrkVGIrc
         JojBGrNyo4qc9W7bJODpPBqt7bX1uijY5sD7E4OlMYo5Eru8cRZCO3uUzLA2vZX+cxPh
         ZSFbBi3GMNWelh4qZ2/ECU2pSwTqhujohHLiYwDwCRsOe7X1nUNXpG1khIP/h/ohwRX8
         6jNSahP4U8pUBsP26GpgD2lf36mMTjkvdcVz4X0bZW4CArL1q37WzWw4+POFiTs5g+Hc
         Ou2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MiQ+xQxx8hd0dlOeoQTIZgHydZebknID1GX7TXEZwqY=;
        b=kG1PXwVYJ67ex5oC/reYjpKSmPM9mUvbaVT1Wwr+UoMP/70K6nhe6uOwrV8I31zS6E
         2P7xxSkB+7qp03die4ZqXRPMHMrSP6KnFAfsITWnzqSG88eMgX21cS9KeF2cp5KlDUeO
         5Qb9hnthnE70GGsae9IPSl63PebVvF9ft+4mAW8xVC3fpq+0tYi1ZlTlIF3jca1WMaM6
         ffVDHHOoampH0qF3puR12Yh/04B/qMfkkw6gSFyzXYhoWXMiZ/RQh8fwIamYYRFnmIgO
         AyH2Wwv8PcWJOfpF3sQ3OAok/xMsU3iqVi4WshWwdmnIDv9r00NkzbFkewzEr/jBXeJJ
         Rasw==
X-Gm-Message-State: AJIora+bvOFcjjL7gtN06bAJgWGf/RTwebT6m4tlGoJAojrBf0GsMmsJ
        hHtYPaCIQ5E1FZx4c4T7DAJWVdIRp3t5HYqhWLcipQ==
X-Google-Smtp-Source: AGRyM1t51RWTLgYvPAUANqa/emkL/JY9rxxZTykAFTNHaWCbZ02W5NqJ5SzgkzMSkS2CC69AQN7HvjqAYJHsNPJ++QA=
X-Received: by 2002:a2e:a5cb:0:b0:25d:7a70:2891 with SMTP id
 n11-20020a2ea5cb000000b0025d7a702891mr13859068ljp.295.1658177896827; Mon, 18
 Jul 2022 13:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220711222919.2043613-1-justinstitt@google.com>
In-Reply-To: <20220711222919.2043613-1-justinstitt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 18 Jul 2022 13:58:05 -0700
Message-ID: <CAKwvOd=P7Wv0Z5YuxkwiqGfXGav9nZsBiC3mxdy0UfyF8D_c8A@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: fix clang -Wformat warnings
To:     Justin Stitt <justinstitt@google.com>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 3:29 PM Justin Stitt <justinstitt@google.com> wrote:
>
> When building with Clang we encounter these warnings:
> | drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1108:47: error:
> | format specifies type 'unsigned char' but the argument has type 's16'
> | (aka 'short') [-Werror,-Wformat] IWL_DEBUG_INFO(mvm, "\tburst index:
> | %hhu\n", res->ftm.burst_index);
> -
> | drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1111:47: error:
> | format specifies type 'unsigned char' but the argument has type 's32'
> | (aka 'int') [-Werror,-Wformat] IWL_DEBUG_INFO(mvm, "\trssi spread:
> | %hhu\n", res->ftm.rssi_spread);
>
> The previous format specifier `%hhu` describes a u8 but our arguments
> are wider than this which means bits are potentially being lost.
>
> Variadic functions (printf-like) undergo default argument promotion.
> Documentation/core-api/printk-formats.rst specifically recommends using
> the promoted-to-type's format flag.
>
> As per C11 6.3.1.1:
> (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
> can represent all values of the original type ..., the value is
> converted to an int; otherwise, it is converted to an unsigned int.
> These are called the integer promotions.` Thus it makes sense to change
> `%hhu` to `%d` for both instances of the warning.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> index 430044bc4755..e8702184c950 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> @@ -1105,10 +1105,10 @@ static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
>         IWL_DEBUG_INFO(mvm, "\tstatus: %d\n", res->status);
>         IWL_DEBUG_INFO(mvm, "\tBSSID: %pM\n", res->addr);
>         IWL_DEBUG_INFO(mvm, "\thost time: %llu\n", res->host_time);
> -       IWL_DEBUG_INFO(mvm, "\tburst index: %hhu\n", res->ftm.burst_index);
> +       IWL_DEBUG_INFO(mvm, "\tburst index: %d\n", res->ftm.burst_index);
>         IWL_DEBUG_INFO(mvm, "\tsuccess num: %u\n", res->ftm.num_ftmr_successes);
>         IWL_DEBUG_INFO(mvm, "\trssi: %d\n", res->ftm.rssi_avg);
> -       IWL_DEBUG_INFO(mvm, "\trssi spread: %hhu\n", res->ftm.rssi_spread);
> +       IWL_DEBUG_INFO(mvm, "\trssi spread: %d\n", res->ftm.rssi_spread);
>         IWL_DEBUG_INFO(mvm, "\trtt: %lld\n", res->ftm.rtt_avg);
>         IWL_DEBUG_INFO(mvm, "\trtt var: %llu\n", res->ftm.rtt_variance);
>         IWL_DEBUG_INFO(mvm, "\trtt spread: %llu\n", res->ftm.rtt_spread);
> --
> 2.37.0.144.g8ac04bfd2-goog
>


-- 
Thanks,
~Nick Desaulniers
