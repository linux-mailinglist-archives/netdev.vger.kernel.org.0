Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5336D91F0
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbjDFIso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbjDFIsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:48:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A748684
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:48:34 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d8so23319844pgm.3
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680770913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4W1/El1Qit9ksuyHkDehv76aGNH702gMKCwzh/+uISw=;
        b=hy1LcUXZdoXkIb5T4xnttLHIXF1gUdl2RrDzLMYX7ISp18tFr8/XK93yEbH6ULpz9h
         WJGK8ioedryjAXWHgeDtR+YId789nS1r7gIt2XriJCeGUC5kscNJlx5E+E5IJjBztGqB
         a0rPjPC7r0VHoGQue5HDXiVQscAB/gd9nb3mysMpbVIeJ7yR36S6XeeX1lQdgnYRp+L4
         Eyz+70/FbkaL4NCHzNFijB0DTltilA6mzzyFJq4oHM8Dj/qdJPeMIpqknQE+BnzAFA0x
         SnhoW2rQMcDeB4cbu+fpHUtGVM1pW+htrLnB0kglC2wCTzBkCyG/Rar2gwL33ZgPIUtP
         xzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680770913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4W1/El1Qit9ksuyHkDehv76aGNH702gMKCwzh/+uISw=;
        b=Qy+P2s/u5BJ3YuaVpFFvtL82lBhZbna079Q3vteWbSFek5+L7l9gz2lFbpMIAs1OSm
         RFKWmzo9SrdBhDa9BM4bQntUmSVHFzp+0we2EQTVQAR42CvocPw3aWXt3o+p4rAEvucM
         pZZFTABmPyohyOGDoewXYn7AHysxVDi6BPLqzihg9q523ClMbzw7XrPUtf8IBN/G+DIY
         PECxMtlP82Eo9cJUIZsTljtIYtkSYSmVC5OoOLIeLmsAHaI3vHzPtMsp6Wbv1fbUXbjE
         QReVtq5vw+Ii/owBy/GAvnsHkYOCpstsXIAfZbdidqm+gUqs7U0jMsq/Z+lQWWgjqFut
         a0yw==
X-Gm-Message-State: AAQBX9ekIfqQKAyUNuWw5e3rqpSFVOxeJPlDijcxUs7iHOc88ajZbElN
        qZTqhCbalqL6kJbguVN8Xbk=
X-Google-Smtp-Source: AKy350aN7lb3HtZtH74kMQvrP2WBbXb65fWdutdrGRcAXUsQE56wekyhHVhQxSKNp3NZEVNBBxQMUg==
X-Received: by 2002:a62:79d5:0:b0:5df:9809:2e95 with SMTP id u204-20020a6279d5000000b005df98092e95mr10020947pfc.11.1680770913314;
        Thu, 06 Apr 2023 01:48:33 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id k13-20020aa792cd000000b0062cf75a9e6bsm796833pfa.131.2023.04.06.01.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:48:32 -0700 (PDT)
Date:   Thu, 6 Apr 2023 16:48:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Danielle Ratson <danieller@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next] selftests: forwarding: hw_stats_l3: Detect
 failure to install counters
Message-ID: <ZC6HWxlZVM5VvClx@Laptop-X1>
References: <a86817961903cca5cb0aebf2b2a06294b8aa7dea.1680704172.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a86817961903cca5cb0aebf2b2a06294b8aa7dea.1680704172.git.petrm@nvidia.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 04:25:12PM +0200, Petr Machata wrote:
> Running this test makes little sense if the enabled l3_stats are not
> actually reported as "used". This can signify a failure of a driver to
> install the necessary counters, or simply lack of support for enabling
> in-HW counters on a given netdevice. It is generally impossible to tell
> from the outside which it is. But more likely than not, if somebody is
> running this on veth pairs, they do not intend to actually test that a
> certain piece of HW can install in-HW counters for the veth. It is more
> likely they are e.g. running the test by mistake.
> 
> Therefore detect that the counter has not been actually installed. In that
> case, if the netdevice is one end of a veth pair, SKIP. Otherwise FAIL.
> 
> Suggested-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Danielle Ratson <danieller@nvidia.com>
> ---
>  .../selftests/net/forwarding/hw_stats_l3.sh       | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
> index 9c1f76e108af..432fe8469851 100755
> --- a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
> +++ b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
> @@ -319,6 +319,19 @@ trap cleanup EXIT
>  setup_prepare
>  setup_wait
>  
> -tests_run
> +used=$(ip -j stats show dev $rp1.200 group offload subgroup hw_stats_info |
> +	   jq '.[].info.l3_stats.used')
> +kind=$(ip -j -d link show dev $rp1 |
> +	   jq -r '.[].linkinfo.info_kind')
> +if [[ $used != true ]]; then
> +	if [[ $kind == veth ]]; then
> +		log_test_skip "l3_stats not offloaded on veth interface"
> +		EXIT_STATUS=$ksft_skip
> +	else
> +		RET=1 log_test "l3_stats not offloaded"
> +	fi
> +else
> +	tests_run
> +fi
>  
>  exit $EXIT_STATUS
> -- 
> 2.39.0
> 

Tested-by: Hangbin Liu <liuhangbin@gmail.com>
