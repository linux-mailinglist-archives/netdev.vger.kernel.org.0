Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631135FAD7C
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 09:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJKHaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 03:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJKHaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 03:30:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4146817AB3
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 00:30:04 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j16so20190047wrh.5
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 00:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=65DZPGeOMiG51jD3mC3VwJN9blhX58ex8VFolpch4hE=;
        b=eJznDTW89xs0tH9NNiWgz4BRsc58OVzipL7hFrU2DWFuSi4xUmlEIubFxEkAnb6fpA
         9HnTByyhgdw5KAkZDkxRQmL0EFB9mlzNR29wsekOYm3Jb5fahYBMqaRD3aafym63fnlg
         hDKqmyBMaLvlr10OJR+8Z6N9SEaowHUcW2UDFsPT0LqNnqY7HzO0pUclyY83YeezW7df
         99fpdOqvLp3+yCsZ0y6sTut7k/OzZrYtnvX7ZTSLpB0Z7z0P8GcRDQrQXuJGETOSr3ih
         pVfBqNJ112LKYpGPoOeFyUQksOnlONlT1kJ9Ymrj2olY1mVHca9VDa848izmOZRDp5Ks
         dk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65DZPGeOMiG51jD3mC3VwJN9blhX58ex8VFolpch4hE=;
        b=fn1fVgtAyf5Iu1Bt6anPmtlUP8iYpQZQ7SVPRo+WePoZy/PG/4ml1Cu5KNAjNbWbMv
         xWj7tOfptUpPCDNxSXToGguwTyQ7R9oJoFEBk8zTeO7erZmnCjeUtW+kklPI/OjHe0yN
         z5D0fXVx2Tot2ZyWsqUtVyzhF2I1RXIjfT3hS7i2CubJKhs6l3GGvosCviuy9uJyBJq8
         1Q7HH5QKjydGxRNskxjuNYL7OZtZ+ycTCtjTlPh7Ka1a4qRV7PEhNKlL6MB7p2RnW4rX
         bGieWwRMCL7n1CnL1yQ/AsfPVruFSp39IH7phRfumy9bGdg4lq1gMnNjyJD20+kPp90y
         vV/A==
X-Gm-Message-State: ACrzQf2Sw5Kdg3zJ+CDEgt5azQStcWfgU28KR5+j4MHPC84mWKBsdTk2
        6HAX0rzkp2iwTSbNQ7X5bdA+T3QeaIxhAySl
X-Google-Smtp-Source: AMsMyM5bYwuhdM8NeI853wEqPN4PbunSgXieDpWhbciwvzZgeMyrXn6mpiGDzciyWyQsNzyubdhvXw==
X-Received: by 2002:a5d:6da2:0:b0:22e:4244:953a with SMTP id u2-20020a5d6da2000000b0022e4244953amr13449578wrs.225.1665473402497;
        Tue, 11 Oct 2022 00:30:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l10-20020adfe9ca000000b002286670bafasm10535297wrn.48.2022.10.11.00.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 00:30:01 -0700 (PDT)
Date:   Tue, 11 Oct 2022 09:30:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 6/6] ptp_ocp: implement DPLL ops
Message-ID: <Y0UbeHfxJvBUc2N/@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-7-vfedorenko@novek.ru>
 <Y0Q9Xcf92OpWPJGW@nanopsycho>
 <a8631728-a76a-41b3-0f88-413c3d7a1b2e@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8631728-a76a-41b3-0f88-413c3d7a1b2e@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 10, 2022 at 10:14:20PM CEST, vfedorenko@novek.ru wrote:
>On 10.10.2022 16:42, Jiri Pirko wrote:
>> Mon, Oct 10, 2022 at 03:18:04AM CEST, vfedorenko@novek.ru wrote:
>> > From: Vadim Fedorenko <vadfed@fb.com>

[..]


>> 
>> This hunk should not be here.
>> I commented this on the previous version. Btw, this is not the only
>> thing that I previously commented and you ignored. It is annoying to be
>> honest. Could you please include the requested changes in next patchset
>> version or comment why you are not do including them. Ignoring is never
>> good :/
>> 
>Sorry for that. This version of patchset was issued to add visibility to the
>work done by Arkadiusz and to provide documentation (or at least part of it).
>I will definitely address the comments in the next spin.

NP, thanks!
