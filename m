Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50CB4CD833
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 16:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbiCDPpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 10:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240350AbiCDPph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 10:45:37 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94270E33A2
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 07:44:49 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r10so13297121wrp.3
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 07:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to
         :content-language:content-transfer-encoding;
        bh=iDxEkSirNtTGFp9qx/Pw2mR6AivoBfcO8GmQO1lgSNI=;
        b=AVcgB0lJj3Jr04WtLVYaKHlmWvabqnKetq4/7gaCY2i4QtJsAM8mpiUdeMdluF6saj
         rT4eHIJFgm2iEV6A/HuQ748rSg04kIoXGOMnkNe8rvmNo7suNIQM1Aft60jRlVzOCZ5Y
         ohrH1VTrlOr/g7Ax+PDPQfeZy43hZ7ZgpoNE784IphI8ZXWshfmRAOlkfautarJYm+5O
         +biZ8SJOeIJzgmdW9b17c3TvSTMp0HsGIuY6PfGp5GupX4OT0cdEgkOP0lXGMwB7gCJL
         lnXoel5e2UhTKcDlzpZvK32NkYruztjzlzau5Rf+qAtZx7p5jxWJRM9FNbqQDKf9Dvcx
         uxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:content-language:content-transfer-encoding;
        bh=iDxEkSirNtTGFp9qx/Pw2mR6AivoBfcO8GmQO1lgSNI=;
        b=qrjU3m+KuKXRAaV35X7yrwkmAsU6WmRCgJnxGKTkYb0Iley4oxnmhDClF/0y6eXTfh
         ELUgfHG1VvJsfOgzOl1XzwM4JVLNKC3BNnAEP55m12gPFgIh0TflUvG0p8dVjOhqRtMH
         NdRT6wBO+EoKiX2uZKIXqk6/zYDaggJu2raIbRFv3sqeJJz/km4+JHrjuYIRXvow5lBY
         b0I3hT/a5niETQaOZdD+VYRa4MWkKGQjiLUL330akK0p6NpnQw3KKcIHOCOFmynipPsh
         XiVlKDDNeQEBY3E1Qo8mfM4yk1jtUkPaXadBve2i/PiKmWkT5u+ish/PYzXaaGR2fwJc
         g3fQ==
X-Gm-Message-State: AOAM531h6nOPVUYKlpLvRiO3ESZOnjMiC1SkrYUimFHKs4qYTbD7AMAb
        PvihiGMq817Mz/b/Cl4Zd7mEIalojZv7Ew==
X-Google-Smtp-Source: ABdhPJwZsQvAhjsgXfWE7fvV6ISGgjnhtBDjIGrMi97gmkFZ52rjnw5nsc+dc2LPHl6Tpyu4RmXVFQ==
X-Received: by 2002:adf:a749:0:b0:1ef:7d81:f4cd with SMTP id e9-20020adfa749000000b001ef7d81f4cdmr24453280wrd.133.1646408688196;
        Fri, 04 Mar 2022 07:44:48 -0800 (PST)
Received: from [192.168.238.19] ([173.237.66.19])
        by smtp.googlemail.com with ESMTPSA id b13-20020a05600c4e0d00b003816cb4892csm21117070wmq.0.2022.03.04.07.44.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 07:44:47 -0800 (PST)
Message-ID: <3e564baf-a1dd-122e-2882-ff143f7eb578@gmail.com>
Date:   Fri, 4 Mar 2022 17:44:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   George Shuklin <george.shuklin@gmail.com>
Subject: [bugreport] stability issue with many altname
To:     netdev@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently there was a feature in kernel allowing alternative names for 
network interfaces

(https://lwn.net/Articles/794289/)

I decided to give it a try:

while true; do ip link property add altname `uuidgen` dev lo; done

Within 50 seconds I got my machine completely unavailable, and ip start 
to show strange errors on any input:

!!!Deficit 564, rta_len=25954
!!!Deficit 1324, rta_len=0
!!!Deficit 16216, rta_len=25911
!!!Deficit 12288, rta_len=25144
!!!Deficit 2044, rta_len=24884

Moreover, many processes in the system got to 100% cpu use: sudo, 
cups-browser, ovs-vswitchd.

I thing there should be some kind of limit on number of altnames...


