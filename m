Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A43B514A8D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiD2Nh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 09:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiD2Nh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 09:37:28 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6619C9B72
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 06:34:10 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id h3so1151238qtn.4
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 06:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ipC9V82PFie+nvLtXqZTiVELTpXRF2kluOqV2ATDd/o=;
        b=RpvdKuYYL82ArlGfHeY0e2JeUZRnEjWcJt6ga8q+uF0hsXkBfN6g7EeyyfOmRZo2lk
         T+dDqpdRPHDCIcUpPbIduLnAShr44NgLPMJGR84bA2ZooaPufQXtx+pfdziaaClUh7+C
         fdZ3cD6MOuP5l9Nb5zoV3kcVNRwD4y/7KWyGEDUuPvS1urLQjVlUGFDbiFI5vPI5h0Bt
         sEM/kpMwJELVULgU03lmXGI+hVQn7OSy1Ki/VjrAKGM4PKquuf/XqBtwx8TyLkQviV18
         LsEUrEynABnIOLNkg/ZzrzZuWxvEA5Gpwr5Zts5PEkI7b8waxEVx75Ah/2bFI65L1aty
         a3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ipC9V82PFie+nvLtXqZTiVELTpXRF2kluOqV2ATDd/o=;
        b=1YpFtJFZJ8d3Y2f3mmvHdHpgUBaNRZB/SzPpiYNzz05+jNkO9dCJRhroTXcoVcLSJH
         78iO6sGnHDv0wkOum3F0SbAFoU9GxC4Hby9qMQSTJt02OFirAWuBoNRQfdUS+/0Uy3LP
         T28GtExgDeeJnwZuOsrfiQCht02iySPvDTQdXATabVAaklBXLrF7OgG9PKXprMPng2Ne
         UmAXhEFIWhY2pCN0LH2SWWH6Eabx+0U/ddTVVsTW2N8Ovxk4gyxD/1PpK5XMn/Fb/QNB
         ktrgXArcdm0N7zw7TEo7T5qASzvLIWb9p4T58jb4t5Pp/v5Quq8nu53pFGx+QviUIRZ2
         YG4w==
X-Gm-Message-State: AOAM533gmkRor0zdhvvf6A6qp2lSRjKAHgwMFqRdRixUtsKnUWCUlaAk
        uzXg4NoL97ZZr3+TF7as3Hc=
X-Google-Smtp-Source: ABdhPJx3iweKB+MlPQk3JOc/lfPOKyByYoSeXHHWVKhSOQ2tQjWHKPpe5DWEudu1hEVP4bbobpcbPw==
X-Received: by 2002:a05:622a:38a:b0:2e2:2fdf:246e with SMTP id j10-20020a05622a038a00b002e22fdf246emr27435314qtx.482.1651239249773;
        Fri, 29 Apr 2022 06:34:09 -0700 (PDT)
Received: from jaehee-ThinkPad-X1-Extreme ([4.34.18.218])
        by smtp.gmail.com with ESMTPSA id h23-20020ac85697000000b002f387e4000dsm1626104qta.11.2022.04.29.06.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 06:34:09 -0700 (PDT)
Date:   Fri, 29 Apr 2022 09:34:05 -0400
From:   Jaehee Park <jhpark1013@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     outreachy@lists.linux.dev, Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v3] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Message-ID: <20220429133405.GA631146@jaehee-ThinkPad-X1-Extreme>
References: <20220428164831.GA577338@jaehee-ThinkPad-X1-Extreme>
 <cf8ae870-8208-b4eb-fbaa-c81be95df05d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf8ae870-8208-b4eb-fbaa-c81be95df05d@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 04:02:51PM -0700, Roopa Prabhu wrote:
> 
> On 4/28/22 09:48, Jaehee Park wrote:
> > Add a boilerplate test loop to run all tests in
> > vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
> > run.
> > 
> > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> > ---
> > version 3:
> > - Added commented delineators to section the code for improved
> > readability.
> > - Moved the log_section() call into the functions handling the tests.
> > - Removed unnecessary spaces.
> > 
> > 
> >   .../selftests/net/vrf_strict_mode_test.sh     | 47 +++++++++++++++++--
> >   1 file changed, 43 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> > index 865d53c1781c..423da8e08510 100755
> > --- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
> > +++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> > @@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
> >   PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
> > +TESTS="init testns mix"
> > +
> >   log_test()
> >   {
> >   	local rc=$1
> > @@ -262,6 +264,8 @@ cleanup()
> >   vrf_strict_mode_tests_init()
> >   {
> > +	log_section "VRF strict_mode test on init network namespace"
> > +
> >   	vrf_strict_mode_check_support init
> >   	strict_mode_check_default init
> > @@ -292,6 +296,8 @@ vrf_strict_mode_tests_init()
> >   vrf_strict_mode_tests_testns()
> >   {
> > +	log_section "VRF strict_mode test on testns network namespace"
> > +
> >   	vrf_strict_mode_check_support testns
> >   	strict_mode_check_default testns
> > @@ -318,6 +324,8 @@ vrf_strict_mode_tests_testns()
> >   vrf_strict_mode_tests_mix()
> >   {
> > +	log_section "VRF strict_mode test mixing init and testns network namespaces"
> > +
> >   	read_strict_mode_compare_and_check init 1
> >   	read_strict_mode_compare_and_check testns 0
> > @@ -343,16 +351,37 @@ vrf_strict_mode_tests_mix()
> >   vrf_strict_mode_tests()
> 
> this func is no longer used correct ?, you can remove the function (that was
> one of the comment from david too IIRC)
> 

Yes! thank you for catching this -- the vrf_Strict_mode_tests is unused 
so we can remove this function. I will make that change and send in 
patch v4 soon. 

> 
> >   {
> > -	log_section "VRF strict_mode test on init network namespace"
> >   	vrf_strict_mode_tests_init
> > -	log_section "VRF strict_mode test on testns network namespace"
> >   	vrf_strict_mode_tests_testns
> > -	log_section "VRF strict_mode test mixing init and testns network namespaces"
> >   	vrf_strict_mode_tests_mix
> >   }
> > +################################################################################
> > +# usage
> > +
> > +usage()
> > +{
> > +	cat <<EOF
> > +usage: ${0##*/} OPTS
> > +
> > +	-t <test>	Test(s) to run (default: all)
> > +			(options: $TESTS)
> > +EOF
> > +}
> > +
> > +################################################################################
> > +# main
> > +
> > +while getopts ":t:h" opt; do
> > +	case $opt in
> > +		t) TESTS=$OPTARG;;
> > +		h) usage; exit 0;;
> > +		*) usage; exit 1;;
> > +	esac
> > +done
> > +
> >   vrf_strict_mode_check_support()
> >   {
> >   	local nsname=$1
> > @@ -391,7 +420,17 @@ fi
> >   cleanup &> /dev/null
> >   setup
> > -vrf_strict_mode_tests
> > +for t in $TESTS
> > +do
> > +	case $t in
> > +	vrf_strict_mode_tests_init|init) vrf_strict_mode_tests_init;;
> > +	vrf_strict_mode_tests_testns|testns) vrf_strict_mode_tests_testns;;
> > +	vrf_strict_mode_tests_mix|mix) vrf_strict_mode_tests_mix;;
> > +
> > +	help) echo "Test names: $TESTS"; exit 0;;
> > +
> > +	esac
> > +done
> >   cleanup
> >   print_log_test_results
