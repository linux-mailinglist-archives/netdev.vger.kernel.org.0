Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2650C55ED97
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiF1TGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbiF1TG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:06:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE3419026;
        Tue, 28 Jun 2022 12:06:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id o9so18895784edt.12;
        Tue, 28 Jun 2022 12:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KX9jc9OA6lP47XCbfqQxmVV0wzSC5gcouuvPJAXYRUg=;
        b=OeDPzwRN8aS7Z6+5YNW5bt5XPl4FCy4QSVBhHJqxN329d25togrn5Rb1NNwd76i84L
         B7xuSHHkGYWmcMb72Ql9C1HHMuyDl0oLivOWUjBnjy+MhG5oI4ttDaHp+DrEtDmzLXKM
         3I9mJ/zzY+Lu79fKWUWJsefzfuhR0co68/X7oNURoG2oFjlDaa5g3WbCDIDlVQ4V8ki8
         scEY8bTCO98WA+OJNk4HK44hhbSnySavnduolO8CTBdlYa0NtRhGuBujZ/HTf811tvOr
         ZwuFRLxfM55Qju0O44wFstrGCn6c8YB6ekWCCR063OnSafM8s0ISjE4kalUi/AhBJCMS
         srHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KX9jc9OA6lP47XCbfqQxmVV0wzSC5gcouuvPJAXYRUg=;
        b=qy8tOiWJBQjY4bz0BYh9/SoPlXSSFNlptY44CSRNU91lLn5iHmkUNOrQGDcfp0FHFP
         38taXzFfh7AABq2fzs0SR+tjH11q+dpnMD77GUEL/1H4xzjTRs8tYuai4jBR+c+6C87N
         iWjfwlTwB9u16aVCg2uFtwYP6etmGuntz/864ruE4FmdbHpx7sJRq62tM1jKfYfgLTd+
         WvsAScopOoHLArmIL/y0KALgVd3fv99Of4ROk5tLiqy1VG2MoSsXWaO/SOon+0qsAk0p
         lfkuE+NE44kY3LNE5nynY5GsLr9RHp0Ewdh1HX/LlHE7bAaV/c0BKQgBluEuTvxFEy4n
         E/sg==
X-Gm-Message-State: AJIora9aorrHBFHVV5zDTGNJGKYpynY3X/AOxq3nRJO7qGQzzwQaYj8g
        Z9EKsffHtto7AqeRC9eMXAvlByVyxd7P3g==
X-Google-Smtp-Source: AGRyM1sSzYaK9iGyQTc/eWqkAAzNRoyNyfBKpAgLFqlWhy6E8+LGYGZqYRdUO6xlkdXZwdgSpDdelw==
X-Received: by 2002:aa7:c6d9:0:b0:435:706a:4578 with SMTP id b25-20020aa7c6d9000000b00435706a4578mr25592987eds.24.1656443187198;
        Tue, 28 Jun 2022 12:06:27 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p26-20020a1709061b5a00b00727c6da57cesm103090ejg.147.2022.06.28.12.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 12:06:26 -0700 (PDT)
Message-ID: <4963e756-506b-d705-d00e-183ba468d894@gmail.com>
Date:   Tue, 28 Jun 2022 20:03:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC net-next v3 00/29] io_uring zerocopy send
Content-Language: en-US
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 6/28/22 19:56, Pavel Begunkov wrote:
> The third iteration of patches for zerocopy io_uring sends. I fixed
> all known issues since the previous version and reshuffled io_uring
> patches, but the net/ code didn't change much. I think it's ready
> and will send it as a non-RFC soon.

Please ignore, it's a wrong version and shouldn't be RFC

-- 
Pavel Begunkov
