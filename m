Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5965F5DE9
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 02:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJFAhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 20:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiJFAhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 20:37:12 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4ABFD35
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 17:36:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 204so583408pfx.10
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 17:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=HGMyotpguw8XwNf4Vq02rrAo8ppFbjjeUnU4iOUzJD0=;
        b=sXb8nG7X+awxg5gECHRiRSFj9Z/RDAacIhnfHwV0X7dTU5sfD5PUfgYxau7ryLJL0Y
         gQddTfD0GpQkjv8NK1vp3Ymgu+UxhxEJMCaORVpBKhLjBmC+oRfAydjn3vCUVppYr8D6
         LIkfnhymJFm4L2yEW6aR1IlhmrbWD97dvz8c0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HGMyotpguw8XwNf4Vq02rrAo8ppFbjjeUnU4iOUzJD0=;
        b=Dgwsk/cx+bI6RYMkVB8tID+iaO9NoXVfC22pV4mYnu4B3nziqrPIGnOnWPyJKfC+i3
         jwPnQCK42Ufj9E8f8QukNmr4iLk2Mp9aQ66DFP+fZC0EJok9vHPGjtOD5j7PNb+5wSsV
         vNnfUJ8XcSVtH4hukgLKrHWNxWUOQWszmUiVrrkDgxRTdtFUe2S+YWp657wn9U4p4zFj
         30F4ggYSYBkfl9MPz/LWZoF99iW6IdmY7PfeqP0IbVVF/0a+umsPdZMKZ1bLfS+UZOZt
         IpQCp439RJHdUy/PPay1s1PI/jERTVrSic0Ld95aDzvF1E36d+WmpYfJ/+deAftkX8/z
         4AOQ==
X-Gm-Message-State: ACrzQf2G4Fg+SHF1MbSW+zrCSQiwRdNeFbcrZR+owcHHXnqjqLfIHyIo
        oNVcXVeiFcMO42lyKfLHY5K7bQB3G8fmQg==
X-Google-Smtp-Source: AMsMyM5+Al5Oqip/VJkIKQcSA9Ig1ymrD4QO1BwJbN96KtWTCk8iccSn8FU3VhDLAg3xTA5SaWk/1Q==
X-Received: by 2002:a65:6bca:0:b0:420:712f:ab98 with SMTP id e10-20020a656bca000000b00420712fab98mr2091051pgw.350.1665016607229;
        Wed, 05 Oct 2022 17:36:47 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id w6-20020a170902e88600b00174d9bbeda4sm17988plg.197.2022.10.05.17.36.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 17:36:46 -0700 (PDT)
Date:   Wed, 5 Oct 2022 17:36:44 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com
Subject: Re: [next-queue v2 3/4] i40e: Record number of RXes cleaned during
 NAPI
Message-ID: <20221006003643.GB30279@fastly.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-4-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1665004913-25656-4-git-send-email-jdamato@fastly.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 02:21:52PM -0700, Joe Damato wrote:
> Adjust i40e_clean_rx_irq and i40e_clean_rx_irq_zc to accept an out
> parameter which records the number of RX packets cleaned.

I just realized that this change probably also needs to include an
"rx_clean_complete" as was added in the previous patch for the TX case so
that when the tracepoint is hit it will be more clear which of the two (RX or
TX) triggered clean_complete = false.

I think the tracepoint should have separate bool flags for each of these
cases (but neither will be used to modify control flow as Jesse asked
earlier).

I'll leave that fix for the v3, in addition to addressing any other feedback on
the rest of the changes.
