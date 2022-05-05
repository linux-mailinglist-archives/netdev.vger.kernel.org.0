Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8899551C5EE
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382620AbiEERVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbiEERV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:21:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25F85C767;
        Thu,  5 May 2022 10:17:49 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i1so4995358plg.7;
        Thu, 05 May 2022 10:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GBeMDGmJ4U1d9VBMctW5UDkywJ/Sjyx6cFCV+k65xy0=;
        b=Tlt2tj/UJXFSzG0yy68kDwvnpEqA/2Z8g+oOfmbRHbSe+j1xzdd5ZR50dX8FwCCnFw
         rrgA5Xt/PnrewsGl7aWSiyAUd/ORHicm2aFBBFEFEcJE+oOMM6JHd2t/Ev7VPOV9538K
         YePVxv+heGhFzlTNnpmo+M7bdBPXgU703YEOFnD0OqYtEnxE1IidPQ+whMR5xlbW7Xpr
         bXIiBmsaozyp0r7KQA8H4tO+blErHEK4yjm0d+O867vhQQ4CYON2SMToQ8iZVaoIRYxI
         FYvvEBerMMDJSWY49VlqK+SjqrXQlxOdimLYf6D+JKayABYiHmpqzSFWC0KQAEkKh36a
         Qo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GBeMDGmJ4U1d9VBMctW5UDkywJ/Sjyx6cFCV+k65xy0=;
        b=dwJpkFDa34ukA8JSBFWlMEmxHcjWk8ENBDO/RbS5IUR1/Y4TeLz628CawrXDW75+RF
         SYAW9kxnC0RbdiXz/BzUAOQ//T8BjtTZn1mVu+8O5weKnX+NkiDLT6gqNl4/WPgoTrLn
         BLKRNFhb8unAB0QK0eCOJEekse1p2eFmVSvCcSHH94fIgwQznOaLcgy+M3Y8z9MyAxRB
         K4ByE2C8nhBD9YEAIa04xOHRPI/FfwpASChMdthkp6Zqh6iq3dLyDnz0kn71jzsh7OxF
         Cq/OdPQLmoi2bNL4Gu1Lbsvte0ytHtSgUWQnVLgabp6p5TtcHYlUhC6byboC9GhldKgX
         pNKg==
X-Gm-Message-State: AOAM531O7h+cLjwXK1RD3FbDBHs/oytFu75sRIhwhALXq2qUAcHOdvFJ
        lhOH3uuFQQM5VAcFOMz+A/u3Tx80PTU=
X-Google-Smtp-Source: ABdhPJzqABd+jbcuW6Nx9rlurAmfJjrkmsXmm0XnmteEsRSbLHpTPB5+xWzYyTxWEHwBPCZ5hq/5Dg==
X-Received: by 2002:a17:902:f649:b0:156:1609:79e9 with SMTP id m9-20020a170902f64900b00156160979e9mr28688105plg.69.1651771069321;
        Thu, 05 May 2022 10:17:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c6-20020aa79526000000b0050dc7628155sm1666618pfp.47.2022.05.05.10.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 10:17:49 -0700 (PDT)
Message-ID: <9eb82218-95ed-de7f-8a80-31b266d43380@gmail.com>
Date:   Thu, 5 May 2022 10:17:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 1/1] firmware: tee_bnxt: Use UUID API for exporting the
 UUID
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Allen Pais <apais@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220504091407.70661-1-andriy.shevchenko@linux.intel.com>
 <20220505093938.571702fd@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220505093938.571702fd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/22 09:39, Jakub Kicinski wrote:
> On Wed,  4 May 2022 12:14:07 +0300 Andy Shevchenko wrote:
>> There is export_uuid() function which exports uuid_t to the u8 array.
>> Use it instead of open coding variant.
>>
>> This allows to hide the uuid_t internals.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>> v4: added tag (Christoph), resent with 126858db81a5 (in next) in mind (Florian)
> 
> Judging by the history of the file this may go via the tee tree or
> net-next. Since tee was not CCed I presume the latter is preferred.
> Please let us know if that's incorrect otherwise we'll apply tomorrow :)

This file has historically been without a maintainer or tree, but since 
it is somewhat related to the bnxt driver, I eventually signed up 
Michael to also review such patches:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=126858db81a5094d20885bc59621c3b9497f9048

If you could apply it via netdev-next/master that owuld be great, thanks!
-- 
Florian
