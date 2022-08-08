Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2B158C3E1
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiHHHSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiHHHR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:17:57 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FA6140FF
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:16:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b16so10156257edd.4
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 00:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tdbeYWER4yytBQEoOMPtFgfMIjFGWgnGBOpnyrXoRLw=;
        b=c9/GHBdcwYQSgH/vpN2NWt8538v+L8cP1370/TyC1nJOlHAjAExGYd2LVJvp06LvbL
         NNw90xSfzFtTnGQF20Sk57wUFew7jgn+ZNjLVsRrW1nwb12kx85HnePxqak5Wx5N+1Kw
         1wI7cSa91ndPWySf6m4+tE9arel7y8TBns2od6jfJ8x3h8/GPjK6fHEbFIDtKJJrSLdR
         mMl+APeQO4j748IJaRdjOqVtw/0OMrPf5ZIB/egdVCJsWv+K/ht1/O22g+KXQ1mAJU92
         5gDn7a+0+qDb3LZaH6O2Loldg4iHf+SY8jPceRFMY6mEF2I9K7qLYnNtfXCzQ2q+RHLw
         NHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tdbeYWER4yytBQEoOMPtFgfMIjFGWgnGBOpnyrXoRLw=;
        b=yMrRzl3rP8Dh0nfujY1jaCQRr4c/1xrE5HAPhprDpLD7gIstdc37bIBMAQByUHbi8q
         O42Uiv8+MGclO87nkidgKDrvanKrmrBKnNsH3Vb/I4frjiqKcOVYrMbxdu9YddLZBXE8
         SwSb4vqpn86jr1tuGI8GliTUhPjycjT33MteYN4G0oDoVkXCf+ZciApu5BAdZ20CNzRM
         HoTevDGJi8FPfQ/vnjPm6PIdsMnO4dRQqy0XAmVxV9civ7U0V6WgyZkDMjvvwL1/w+Cn
         7H5CZMqMwiZtsBL9kcNUXwy4QW8nAGUM3VUu2Ivlyg/aiiCe/QqAEEF62lfdEMzjEYGq
         +hSQ==
X-Gm-Message-State: ACgBeo0JbkQ0/1QzzWOCjIdUuXHWdJTQ4fnjDjy1M0vB6bPBnbLA4h0O
        IxW0UuHZxxnBTH/DK6UUWgAs5g==
X-Google-Smtp-Source: AA6agR7vbkGvaZKXxHwPly0HjpI42eo5Md5uw/fJ0NZuSdmhWWdH5P+fuydVZO16b9Zb9H9lmPHiIQ==
X-Received: by 2002:a05:6402:5247:b0:43e:cf46:45b3 with SMTP id t7-20020a056402524700b0043ecf4645b3mr15128065edd.153.1659943001801;
        Mon, 08 Aug 2022 00:16:41 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b19-20020aa7c913000000b004406f11ba7csm3342194edt.32.2022.08.08.00.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 00:16:41 -0700 (PDT)
Date:   Mon, 8 Aug 2022 09:16:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: cmd_sb_occ_show doesn't call dl_put_opts
Message-ID: <YvC4WO2y4+RCTr1G@nanopsycho>
References: <fd4da86c-e806-8261-970a-fc563758a9e1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd4da86c-e806-8261-970a-fc563758a9e1@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 05, 2022 at 10:18:22PM CEST, jacob.e.keller@intel.com wrote:
>Hey Jiri,
>
>I noticed while looking at implementing policy checking support in
>devlink that the cmd_sb_occ_show calls dl_argv_parse but then doesn't
>call dl_put_opts, so it doesn't seem to be sending any of the attributes
>down to the kernel.
>
>I am guessing this is not done on purpose, and is just an oversight,
>caused by needing to send two different netlink messages.
>
>It looks like the code could use a dl_argc check to determine whether to
>use NLM_F_DUMP and call dl_put_opts to ensure the netlink attributes get
>added..?

Correct. Currently we are doing dump all the time. Should be fixed.


>
>Thanks,
>Jake
