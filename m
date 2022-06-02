Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04ED53BAE8
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbiFBOiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbiFBOiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:38:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40812823D9
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 07:38:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id i1so4685720plg.7
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 07:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=Z/YG4PipnTkB7kFCLB9Ko0aJKnsghVne2YT8UWY752k=;
        b=bud6KC+IEJkA6UiWdb0XWgCPZFOyuGnbI0JcrvTAcs7MVHNMHwAeHO4gVI6VuyOJOA
         jBeWE0tjfbvr1sWtTHrQ5Pc/lY32vpbdscy1jntHUk8iRt9GspfMxKUwjBVts+q6X7aR
         v87q9vJUEsBtElB+uDT2VH6ujaeGT+QRyw29VwBL/yfKHcfAaZaG7WjA31P3HQTQA04U
         uqcJ8VFRO4e2Axal/SPHOuqcsS6JCaxkY9jKoXVpqccy3piFY7XCtu8jcom17rxRANck
         0Ul7hwSuXbslkUtrhF+CWWY7IXgcKjYGHlhLeLxKHYV/IUqSL47F4p/1egWE/ObhS+kG
         pW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=Z/YG4PipnTkB7kFCLB9Ko0aJKnsghVne2YT8UWY752k=;
        b=3k/BlDLkgQA9ynBm+JADk6Ig99H9HPXHwznM8SolWUJlRjwtpA/U0Qg66EM8jU+GVc
         UypGKG/bSIDzOOzFN/pWNy67HM7Mel9SvEX/WDvx7D+2oiwiGbjHgsK+wkZYWBUd0VVb
         oFV/UZ+kYQAhG0bWwV1qFu70xCobC00c/Vj7CtqIKVCw2wiNeiugi13e85QJEBEyBEth
         HKLIkAEA3emZh4mvQENI7o6IGSerBqt8AFrmULklG54pHTy7dWodkWYEMgevAWk1Lz3v
         3KzMJ0IWpZEJoRp5c6kpJunF8H6OWxsOIyuGb+QqAu7GxFLigt+tR02z7iChnHWlrZOc
         dpJQ==
X-Gm-Message-State: AOAM530NQ7TiKkQmrZ7ltaDRFsEYQst+cdg5Inq2u54qWkvbCEeZvaI+
        3oS/CjS9ZDaG8ul4I/6B8O5suw==
X-Google-Smtp-Source: ABdhPJxcsCyYB+lxTTfZ4DtkTxkL02+rhEC1XISCYE5I4g2r9qLwMTwqvhSmR6VRmrWdwKMzixf47w==
X-Received: by 2002:a17:902:9f96:b0:163:dc33:6b72 with SMTP id g22-20020a1709029f9600b00163dc336b72mr5360865plq.34.1654180690018;
        Thu, 02 Jun 2022 07:38:10 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id l12-20020a170903004c00b00161929fb1adsm3569827pla.54.2022.06.02.07.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:38:09 -0700 (PDT)
Date:   Thu, 02 Jun 2022 07:38:09 -0700 (PDT)
X-Google-Original-Date: Thu, 02 Jun 2022 07:38:02 PDT (-0700)
Subject:     Re: [PATCH] dt-bindings: net: adin: Escape a trailing ":"
In-Reply-To: <20220602142917.GA2254348-robh@kernel.org>
CC:     kuba@kernel.org, michael.hennerich@analog.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, alexandru.ardelean@analog.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rivosinc.com
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     Rob Herring <robh@kernel.org>
Message-ID: <mhng-d5bd6ca0-1237-49bd-b55c-18fb483bfa98@palmer-mbp2014>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 02 Jun 2022 07:29:17 PDT (-0700), Rob Herring wrote:
> On Wed, Jun 01, 2022 at 06:28:09PM -0700, Palmer Dabbelt wrote:
>> From: Palmer Dabbelt <palmer@rivosinc.com>
>>
>> 1f77204e11f8 ("dt-bindings: net: adin: document phy clock output
>> properties") added a line with a ":" at the end, which is tripping up my
>> attempts to run the DT schema checks due to this being invalid YAML
>> syntax.  I get a schema check failure with the following error
>>
>>     ruamel.yaml.scanner.ScannerError: mapping values are not allowed in this context
>>
>> This just escapes the line in question, so it can parse.
>>
>> Fixes: 1f77204e11f8 ("dt-bindings: net: adin: document phy clock output properties")
>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>> ---
>>  Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Already have a fix queued in netdev.

OK, thanks!
