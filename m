Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB5B5501ED
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiFRCOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiFRCOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:14:45 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBAD4D60A;
        Fri, 17 Jun 2022 19:14:44 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id c189so6209738iof.3;
        Fri, 17 Jun 2022 19:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=M1p64PXNFQ+QJHRFIW9jzsBw6K4zZxCcuOri1z5U1P4=;
        b=aZjQlPh8lk7CbXwSYnZM22eXJr531dYu2wDy+5rDRbCZy0jUgSgUvdzKw3lF9nDoZs
         pQz4wUP+vggQQ4hUgm+wKB5Xq6Yolt6aZhUg1qcqiJzs3oOH1j65exWYGTbOJEb1vLzv
         CUP6goWNAdJlAvsLIn92Pz4/w6y5+XcK7F43pxEwkPbx4r3154c9bgGGNSDu/ny7Zc3O
         1kmY/az1CDurqpN0gx+fjizcsAk60EOu253hCZvtmS38TxULQYf0wNsaAikSdOx3PIb3
         BDXgK5uAjhEh5VMguarIrut0DZCOyr5NdA+lR28RYZd1zNm87o+5OtPmMQG50zeA+rAu
         +GdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=M1p64PXNFQ+QJHRFIW9jzsBw6K4zZxCcuOri1z5U1P4=;
        b=WqU2L6mwRRfsk2RItaQiOFHgrzHdvNHOS1+lPDwB/VCN6fnSpYoBFwWYrIZFufvxXz
         i8UqaaWkzu4mBz8ejVW7ayupCJOHv2630Fk+Z4kezQEt19Xsn9BcdZHUKhcKX1UcAf4s
         GT/2VVPIyVk6U8ky42JKw7OFUUJPwkyNYKeyxNr9Qgvjw1+gUfpUu3dzdKIucWHf0asq
         w7LBe8T/shlkRXUyUsJxOlu2hCan1AqiSACzUHlHhr6MNtA3WatT9tVfYX6zKC4R3ELz
         rv4k+GjX+FzdX/5L/dGQYW8YEW2NsojZ9MS8IJ9OsYyYATggRuCzfx+rJlBK2WsBtYWW
         WpHw==
X-Gm-Message-State: AJIora8csOyx8hPPz1N3LiCGpbqfV85rAFq4cMfis2QfnhSuA+M27qj9
        fBD6FxLxrk2R+ofhcUlBN6oRH/LMKv2ObA==
X-Google-Smtp-Source: AGRyM1ti136lxxVIfHwJns3FQCLlvAYRIN9SNBnnkCEMET4go/zlJT+5YRfR6hN6tAVhk89NqAmCYg==
X-Received: by 2002:a05:6638:d55:b0:331:ed23:4c8a with SMTP id d21-20020a0566380d5500b00331ed234c8amr6817240jak.62.1655518484342;
        Fri, 17 Jun 2022 19:14:44 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id i40-20020a023b68000000b0032e3dd0c636sm2870661jaf.172.2022.06.17.19.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 19:14:44 -0700 (PDT)
Date:   Fri, 17 Jun 2022 19:14:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <62ad350d78314_24b342083f@john.notmuch>
In-Reply-To: <20220616180609.905015-7-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-7-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 06/10] selftests: xsk: add missing close() on
 netns fd
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Maciej Fijalkowski wrote:
> Commit 1034b03e54ac ("selftests: xsk: Simplify cleanup of ifobjects")
> removed close on netns fd, which is not correct, so let us restore it.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Needs a Fixes tag and likely send it to bpf tree unless there is some
reason not to.
