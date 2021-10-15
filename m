Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B678642F679
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbhJOPDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 11:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240636AbhJOPDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 11:03:02 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B889C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 08:00:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id g25so26910684wrb.2
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 08:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RBjjLeiWguUvJEs61LGvxzcOuVVwGqpZvu6xGLNcQxE=;
        b=Itr/Erp+2n16kmSlIzgLZ7us7a3qCYej2DFLFJtKE7utAoqwfiU1p032ZmfVUwJrvQ
         MNmp1vhX2U3vxiYdEFGItNPK4SQn1+VqY8QsZAtqM87WDBHNJf6V+XmVLlTQs42gc6kb
         T9kZ+fNu2gfkOAeWwQBOk92IA2HQsbaEYcWkOaO/P28PhlAYw4poa1K1IeC+J3IIgP1i
         htj2mq+VNF0LuhV8wkelX6oycFnzBZ+gnZaXZgOITdwZvi++GLKyQIPMJT0QSEy5HyBf
         kZA9vs/gFxbd7iH/5hP2JcssLc9aUhkzLVUjP8JhJVo+1HC3vlR0U1phgjRm7euBLV5e
         rZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RBjjLeiWguUvJEs61LGvxzcOuVVwGqpZvu6xGLNcQxE=;
        b=X5VMqc/CI49B0vI6E2aRQmL5Ej4hApA61GlczXIAHf1+buLmrpXJL8uFDqopfXzIe+
         5wbYwURsOWmhnaqdsKkrXLwWpXnkqBn+kbVuzwGTiqcatiQhQqNV4sZ9uYfYy/UzeMek
         ZPRiK/VYHqPoec5TeeCIbf5KcqcE5eKzOq1a8qIUL6lHyT+V/vYbBd1Ge+T49MfIzSkw
         A6oP/TU4AXdNMS1aeIOGqQFfpttvb27rN/qzaHMzKfAaHEmm7mMKmcDEd/iSS3kGea/Y
         O8BQtKCyueDB4i5XKD+/8NA3N0NCYrg+di0xzbmgZv43uUkReXDtlKy9afi36zEADFZJ
         jVgA==
X-Gm-Message-State: AOAM533VSZy6Vhx5nMvrdVzHHspwWsXkUcIODNe3TH8O1uMhMkWBNsad
        zn3C/GrEfsanaEGFX6uUohywvA==
X-Google-Smtp-Source: ABdhPJw3V0tV2tqFwx5yiba7x713EFDNGe3fhRlXpAn+qCCXXHMAMNVbT05amOnKCklh4pF7y+mogQ==
X-Received: by 2002:a5d:64e2:: with SMTP id g2mr14917796wri.253.1634310054940;
        Fri, 15 Oct 2021 08:00:54 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:a58d:ec4:bbb2:aed8? ([2a01:e0a:410:bb00:a58d:ec4:bbb2:aed8])
        by smtp.gmail.com with ESMTPSA id o8sm11730076wme.38.2021.10.15.08.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 08:00:54 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [ovs-dev] [PATCH net-next v7] net: openvswitch: IPv6: Add IPv6
 extension header support
To:     Ilya Maximets <i.maximets@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
References: <20211014211828.291213-1-cpp.code.lv@gmail.com>
 <1d0a5e90-b878-61a1-99af-35702b72f2d9@ovn.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <69204286-6dad-dade-f749-8603da82eb48@6wind.com>
Date:   Fri, 15 Oct 2021 17:00:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1d0a5e90-b878-61a1-99af-35702b72f2d9@ovn.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/10/2021 à 15:56, Ilya Maximets a écrit :
[snip]
> Not a full review, but, I think, that we should not add paddings, and
> define OVS_KEY_ATTR_IPV6_EXTHDRS before the OVS_KEY_ATTR_TUNNEL_INFO
> instead.  See my comments for v6:
+1
