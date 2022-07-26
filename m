Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65556580E2B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiGZHqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238220AbiGZHqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:46:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257A414009
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:46:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id va17so24712666ejb.0
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fe8FCWA8Wm+qfcWf/r36DmGWESGg9aUro2v60ffBvEw=;
        b=GUklJ/i54T4mu60z0nxww87BZMtd+OqqaYvw8WN8x7hVhl0fo+dY4lfDfvyepdp0RW
         XvHrBWy5JOY4W7LR/w6jzWEvopy1JUWPRCKBCXTqI5lUx/RhNZgW2IXfnOI06W3kNUij
         0hIXIV6SrNlIdT4O80FDGP/grKL6egfnglWraIFqq7DHY6/IHAS/TJjVLkK5AoyVBsSP
         3h8Ymz6H5vvEDz9Kxpn9R/Z9xDb3c9TuVDFj1Mio7884gHbvCCRRDGh90jodk4KlFXMx
         dninpEY7xoE6oahlH1lsKYTZV7as9eg1KjDyS49Xf8eS83gjVxttRRY5stHJLzBTPwft
         +A6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fe8FCWA8Wm+qfcWf/r36DmGWESGg9aUro2v60ffBvEw=;
        b=2omhgUHjEc0nV2O6H4N6MP4mMNzv8ts1hwlKqxCxUBvo9eHL794Lmyp4AIebZmFg8A
         bTT5SLdSY6IyZ1KBAYoc4FZOOA4IYveqM0mfajKzDt3W1lEaFR21rKTe0NU4bIsSfX/F
         h9HvO1yC0DaTdvXLfGoLM+RTzt9WtepKtjJamUKmAijGmqMOC1YS9QFzasbQYrU5Gpol
         L4+01Z/aoKhldMEYafRD1LSfO2M2PhU7qQ29exo00pbOOQXtdJff7gKqcQrnuPOW2hTK
         eSJqlUdJj24C0/ifn+pGXAm5bqaatzi2EpuxoEXePRBJ7qwWtsHLhxaxKO1eyGHipdId
         STcg==
X-Gm-Message-State: AJIora9jFOZIxfUV8Eq5E77liNn4RvI9LmYDMhPFSMEJ9MJ3ddzs2/7h
        3E0fpDXhCcAEMCULyhKEyRU2MA==
X-Google-Smtp-Source: AGRyM1uFO/gjeVgZVMo2T6ekZxcZoMDquiuvwmOnarobeFUlsNL4N3QwgPCJGv8U8M2sp36My/1EKA==
X-Received: by 2002:a17:906:84e1:b0:72b:b109:7636 with SMTP id zp1-20020a17090684e100b0072bb1097636mr14028353ejb.10.1658821599484;
        Tue, 26 Jul 2022 00:46:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906319a00b00722f069fd40sm6075203ejy.159.2022.07.26.00.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 00:46:38 -0700 (PDT)
Date:   Tue, 26 Jul 2022 09:46:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org
Subject: Re: [iproute2-next v3 2/3] mnlg: add function to get
 CTRL_ATTR_MAXATTR value
Message-ID: <Yt+b3XGbAixaf124@nanopsycho>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
 <20220725205650.4018731-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725205650.4018731-3-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 25, 2022 at 10:56:49PM CEST, jacob.e.keller@intel.com wrote:
>Add a new function to extract the CTRL_ATTR_MAXATTR attribute of the
>CTRL_CMD_GETFAMILY request. This will be used to allow reading the
>maximum supported devlink attribute of the running kernel in an upcoming
>change.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
