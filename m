Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D5C6F273D
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 02:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjD3AnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 20:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjD3Am7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 20:42:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DCB199B
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 17:42:58 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b70f0b320so1612855b3a.1
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 17:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682815377; x=1685407377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0oNmLxsZHhOQ6+2zu7Bq4EnTnhKPUwB6C15Buip4xI=;
        b=KA7r6kSpGuu9cQCWic/v2V8/jfFW4x9Ty6/6S8gmimpLaDZrG49iJ7NrFhy28KrPfU
         52mUmMAX0BTa2AoJh155jwh54HyUJ4lI9pXDGc75suCUL+N/kEnAZJThDDr2fiICFQhf
         v5Zjik8USunoJdnmO5z6tEodW3fc4JM+qHZ04C0eKZGMDHLmSnTX9cX0mlrJCNv+0VUB
         2pB2LHTnjZbZHHjAgl5OuaMRGu71kv1/2XEPs9M+u/UX3WOULZcpI5OIH4XhQoDw0mc8
         K+j+yVb1eKdduvjbvQ1ipzNBCh13Imo77gEa6+P+vibhAX9O8gtwQ5Le3bhagOqLPQSc
         bWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682815377; x=1685407377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k0oNmLxsZHhOQ6+2zu7Bq4EnTnhKPUwB6C15Buip4xI=;
        b=aFqJvqSro7Qcm3ZbnKbxlEG9OzWWOWGOHpz7ReP8Bg9/EEWnXqj7vUpB6VXgmfGFg4
         Do4lkASyaT4EDNNHpKAeyMsg3dbdynY6kHTRH1EESCgh4nyY8AneWsXY6xgpZr9dDAg+
         0gg92h2NDzdR9kfUSND+zxjVd1/jKpOkbPw6hwnCA++ZdK48QxYPB0LA6eQJFLwUedNj
         BX7B4gVYMDRpPD5IYjo51KVRmbzX0DHfWSaKUkeKgB5SXiyVOwv3XtZF7qQ6fhIvjWQJ
         xnv0YASqU0LYI07zpUBb51Y5CYlaMwVafbIKcejW26BeWzqCTPFGwUXZFltVaQ/RdUyz
         lZ0g==
X-Gm-Message-State: AC+VfDwrWdGns9O7M2/PKKBujjlu0ONjrG/hZCWd20lryqwxQQmHCYHI
        HLUCFHzxdHbslSI7iJLu77iKs6q2046UeoWaAjZC9A==
X-Google-Smtp-Source: ACHHUZ4venty8dMALQSBaW2ct+XkQoqYV1jrYHNshG1QPjKFx81xiVliQBjVTTWByvW9hNlIpzmHYQ==
X-Received: by 2002:a05:6a00:2d93:b0:63d:4358:9140 with SMTP id fb19-20020a056a002d9300b0063d43589140mr14990362pfb.34.1682815377644;
        Sat, 29 Apr 2023 17:42:57 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p10-20020a62b80a000000b00636c4bd7c8bsm17337004pfe.43.2023.04.29.17.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 17:42:57 -0700 (PDT)
Date:   Sat, 29 Apr 2023 17:42:55 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 09/10] tc/mqprio: add support for
 preemptible traffic classes
Message-ID: <20230429174255.564a9401@hermes.local>
In-Reply-To: <20230418113953.818831-10-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
        <20230418113953.818831-10-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 14:39:52 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> +	tc = rta_getattr_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
> +	/* Prevent array out of bounds access */
> +	if (tc >= TC_QOPT_MAX_QUEUE) {
> +		fprintf(stderr, "Unexpected tc entry index %d\n", tc);
> +		return;
> +	}

This creates a ABI dependency, what if kernel config changes?

