Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096CA6668D1
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 03:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbjALCXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 21:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjALCXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 21:23:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885E01CB3A;
        Wed, 11 Jan 2023 18:23:33 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso22054913pjp.4;
        Wed, 11 Jan 2023 18:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DkGFSKCyKp0ASiHldNOuzRJD3oIYkSCW1wbocraF8Mg=;
        b=j3+X/DBXF4y6NAs0eiywd6OBhPY3Sn7RUNuRzukXTy7zACvueNlMqAiQEZFevcT49p
         SRLTPML4QJA1zvtW4YoZ4l/WND7zeK0vTfJ3DLeohZGCc3y41VIGTbj6qOkIdG60MazB
         HLXsuR2JTaPJhw5M/Mrr1SXrNgaOBfzG4EJw0Nv36eEifuEwpG2pPn0IG4WH21rzTCQ3
         gDjMYni977Zg/AAokA1uf7/ghdGsSmvpHLZ3eNoEixAcb9DFtMGJNpdbxdkGHRgnJAJ0
         mhiEeuq5Lc7WZa0uImXgI4YWXhq40fvBAX4cius6JViSZ/U+2+yZgZuUXewfOxehKVUP
         zuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DkGFSKCyKp0ASiHldNOuzRJD3oIYkSCW1wbocraF8Mg=;
        b=zJrTkYrzjbttris7dfUcpodhv8tptUnCtwoLuHCA1rEEJAgOtrGfj6Kn1ilLxAdgil
         /21f5eMfT1R5YBSQkMQ6Ap4uGspvmCPysscCJDjhT5t+J9nr/rbEPUCRyiCaOoXhSPsH
         JuzkF8kdCyjyMrLB6r3mtv5UAl/g8aCRoRtNjc/A+aF+vakzW+1ULK9uLtQ738eqcoxe
         6lA0Roiut4vv1GITqGn5Zh8DYurtdXYSJ7xqNrVGk07Hu32uoajGA8y/jJ17m2WvxAFU
         277DtQi3c6yy8eeyRT1d5+k/a3EWBgUuEW1+nbg2ZkoT3jWX+7/cetKeAsN+BCibXLpT
         eFtw==
X-Gm-Message-State: AFqh2krdYF1z5EfFFVXMR8cEhAhYg/wtMSwizT98WRqChpiwryJC4yse
        4dDpegj8sZwh1iyVF3N5wu1gs1qfJLs=
X-Google-Smtp-Source: AMrXdXskPkpkPLDHKbzyR9TwUYSG3ELZb9xxzzNN1rNxvKVfoIzkYJYNBM14L4XzY/2LI060UFuPEg==
X-Received: by 2002:a17:90a:b104:b0:227:13b4:6f33 with SMTP id z4-20020a17090ab10400b0022713b46f33mr12836254pjq.1.1673490213002;
        Wed, 11 Jan 2023 18:23:33 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:df0a])
        by smtp.gmail.com with ESMTPSA id om5-20020a17090b3a8500b002192a60e900sm11367835pjb.47.2023.01.11.18.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:23:32 -0800 (PST)
Date:   Wed, 11 Jan 2023 18:23:28 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next v3 04/15] selftests/xsk: print correct error
 codes when exiting
Message-ID: <20230112022328.zbazaaoxbxfornh6@MacBook-Pro-6.local>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
 <20230111093526.11682-5-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111093526.11682-5-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 10:35:15AM +0100, Magnus Karlsson wrote:
> -						exit_with_error(-ret);
> +						exit_with_error(errno);
...
> @@ -1323,18 +1323,18 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>  	if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
>  		if (opts.attach_mode != XDP_ATTACHED_SKB) {
>  			ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
> -			exit_with_error(-EINVAL);
> +			exit_with_error(EINVAL);

My understanding is that you want exit_with_error() to always see a positive error, right?
Have you considered doing something like:
#define exit_with_error(error) ({\
  if (__builtin_constant_p(error) && error < 0) // build error;
  __exit_with_error(error, __FILE__, __func__, __LINE__);
})
would it help to catch some of these issues?
