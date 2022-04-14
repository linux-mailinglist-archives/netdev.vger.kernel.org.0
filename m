Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C216A501E19
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244300AbiDNWNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238638AbiDNWNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:13:20 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06E7BA316
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 15:10:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id p65so11799377ybp.9
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 15:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DZfAXmU2hqQ7N7/AH1GP9qtLRzwkcqKlYE0yKKgjb7k=;
        b=gSiNo8zhYKYYP1Qk0QOkddo87HqXas4Rv+V5cY/w+3k8MDVYZGiOP6oGBZ47PQFGYe
         rQbEQZhRcdEJC9LPO5zpe9tH1Hz6TNkoZ+1qdM/J8b7THAFI6nI0bNyqsvBUd6EhJUlo
         nROpvtvaQZvBB6gmyvkhtloOFZ4fYbJSe2yuQHzkpF0NnoPoeGTvkPgaXf9hKXUBq1uj
         3Dd+lAMy94Xhl9fP5plzrHrpW//1vLo2OA7y8Hdwxnt++3nlNqkmwOrVg4rCk25ErJ9y
         QqfTYYP5sV0CDJ5kg/Z2N02cPyhvXw46DpmB+/aJfHSDvgUYdeABVdjWzvVgr1zPA3g/
         P6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DZfAXmU2hqQ7N7/AH1GP9qtLRzwkcqKlYE0yKKgjb7k=;
        b=g5hYkXoSNYikIr1XlL2JEr8YBFZUf75uVgnNPOKU+S6Ptb3K8ygDwr4oyyL9YKVUPw
         mK7bVn5rTg8/W+dnx0B0hhqCktO2LnXl3yGY0FP0ql0cQWlsn57grZf4HFt0mQeBChP9
         qRT5603hSeeWMYBFF9G5h89iLVQWvoLfFvHtO+Zjt6PqIgVEY+TfWU/yhzUcNeM67fjr
         lCWv6bmH/0g6hxVWUX932y5WAoCfX8SWyUlXJwS9m139pnNbJVLk983y1iRT8xnAxbb2
         UFy/vyjJwyPGGjeLQ8f1fPr/G1K71oxXUFo0Y4Y9ihaOY9loxsWNkJS4mJS96OB+9zcx
         Ybmw==
X-Gm-Message-State: AOAM533/lN4CW1bGVeqI3B5AJ8mwfh9ZwWf84Ha4ieQtSImaB130ccFq
        qMqNOG0YGDBR5HFVyXnwlf/V9zkV/tibwgKhTV7yow==
X-Google-Smtp-Source: ABdhPJwgPxHCosV3Ao0zxjTFfD6aYdSt3cJVe8Bw38k+Hc9UszRnQ+mZJQMcNMMe7CbnrnLWSywRXkEcQON9539DP0Y=
X-Received: by 2002:a25:e484:0:b0:63d:67cc:cac7 with SMTP id
 b126-20020a25e484000000b0063d67cccac7mr3261196ybh.579.1649974253210; Thu, 14
 Apr 2022 15:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649780789.git.lorenzo@kernel.org> <a452ed5f5699447973c237cad1bd6c74bc9e7031.1649780789.git.lorenzo@kernel.org>
 <20220414131716.2e2c72ad@kernel.org>
In-Reply-To: <20220414131716.2e2c72ad@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Fri, 15 Apr 2022 01:10:17 +0300
Message-ID: <CAC_iWj+AWK6=Ps9NFcJEF9abc6YSgzOuR1zXW1yG0y5+4UBSYw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 1/2] net: page_pool: introduce ethtool stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        jbrouer@redhat.com, andrew@lunn.ch, jdamato@fastly.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 at 14:17, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 12 Apr 2022 18:31:58 +0200 Lorenzo Bianconi wrote:
> > Introduce page_pool APIs to report stats through ethtool and reduce
> > duplicated code in each driver.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
