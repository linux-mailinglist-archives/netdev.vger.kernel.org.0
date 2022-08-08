Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B7558CF65
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbiHHUuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237485AbiHHUuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:50:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF299FE3;
        Mon,  8 Aug 2022 13:50:04 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id o22so12793714edc.10;
        Mon, 08 Aug 2022 13:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject:from:to:cc;
        bh=S6Jqr3i6MlgNxdJRw4bzd/pzQcm+bxvwrwCXIw8V0l0=;
        b=L7wDsYYbfh2tUMtVSUTPt7tXkjTJA7tYPYOhPEXFJ+I/GP+KJQJl+xbvJNCzWFRFt6
         vwvLCjBL1zO7YEqIlWQAlqCgP0Eki98qtx77dBRNsMqv8ICKDZm9VYRvJMg68N2aHnsO
         RR8h4RIU3EmUWJxQOWiVd3bv6MFAsuwiIH+ar82hsXaFogkb29UMiZtOYybWOguk2uUu
         x8dI6qb7RFN6y1ohqMmtvKVbxqOrKqSPGsDoPHcUPcY9qI/4WEyC43GiD8IhGXEbokf0
         p+2ORGzGQTNOoaSeSQUBR8/G0it65j0g+Y2Mu5bBdLkKMC7xF7N6V7j4POrQFFROsIM0
         rwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject
         :x-gm-message-state:from:to:cc;
        bh=S6Jqr3i6MlgNxdJRw4bzd/pzQcm+bxvwrwCXIw8V0l0=;
        b=AMi7a3FJXy88K1kIVP6oJzj8bAMJVjzngMye++H1rlUYsqBOZD5qJDYsazSLuae3MP
         ke1JqJAEh484LG5eqGU/9mFc+NzMuVTQG/aNo+Z+sbm+BAq2po4B5+TGfzMB0k2byEwL
         1ii4dYehP8M3v2cdMQTySCW4jDApmxLSwKvNEkzIEb9pw6udAhd8ImxF8lQGm4zJHoNr
         vYPKiilocfXC/eMV7pFs+sTU2iPKr1GUt8mF4wvAv37X1pLrXklhuvQiQvzZGcsV3lRr
         RBTfmbPrHuMdSggbSwNsIAiTVq6BTeKhgg9WBi5DugZahSgaIVacNZPaBngIFq8z3zsR
         2T5w==
X-Gm-Message-State: ACgBeo3c9fqFsOrrIflnJBU0jNBoSKoLcKDXMzeTtPjvi7hyFpqQX7iL
        zOL3MLKkxKyjeFUdvtQeLN5uiMwsVzI=
X-Google-Smtp-Source: AA6agR42Wx7WCIxo5hGgyaxdWEEgNp9P/L0b63L/Ly0EdWreH8vSbaNmNwSKuz/9KIbb8PB/3sCDjg==
X-Received: by 2002:aa7:d49a:0:b0:43c:fed4:c656 with SMTP id b26-20020aa7d49a000000b0043cfed4c656mr18845862edr.312.1659991803422;
        Mon, 08 Aug 2022 13:50:03 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id cq21-20020a056402221500b0043ba7df7a42sm5024741edb.26.2022.08.08.13.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 13:50:03 -0700 (PDT)
Subject: Re: [PATCH v0] idb: Add rtnl_lock to avoid data race
To:     Lin Ma <linma@zju.edu.cn>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220808081050.25229-1-linma@zju.edu.cn>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <c8db4a58-262d-154d-c84f-f435ada348ba@gmail.com>
Date:   Mon, 8 Aug 2022 21:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220808081050.25229-1-linma@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/idb/igb in Subject?

-ed
