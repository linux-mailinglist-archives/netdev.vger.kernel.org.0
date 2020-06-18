Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A921FDA0B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgFRADo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgFRADo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:03:44 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD1DC06174E;
        Wed, 17 Jun 2020 17:03:44 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id w18so5064315iom.5;
        Wed, 17 Jun 2020 17:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=98+i5dkMtE4+TEvWaHDtOM0EnzOztfZss4zhEWcX2kI=;
        b=o3NvzfDWgFY4oHGO1iGsQRDSs6di7DMm5EiPw91Ql3MdX2O13ebIEoHUSZV/Xb4u0/
         EfuVRbJOc81gdls1lo7Xu3/4tOekoOJxhq/nPHxx3kyFLvVrChd6VNQD7+5zlAPo2Zoh
         qf5byJaEe0XvY7dXtr2wA4JqYaWaaLvkcGVtoOMbAPauyMyofTpzDO0O/eWfOUhVv7Kp
         QUKzxGHT8idmy5p0ALp3+q0teeR+Kw+Pwgs+4z8LF212dSzE1QF8tA7Hj/PFLpFfwPP2
         3D8Bf3fJVKalsaSHtIxmPE4GVaK72ZjcA72Eto2ROH26T8FSdYlxRpVl5iwuHrUuORjU
         dmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=98+i5dkMtE4+TEvWaHDtOM0EnzOztfZss4zhEWcX2kI=;
        b=uQsFB8zDgjAahM5SabdXYHSPmreMnwf/bTd27cj6XDj3hc3e1/4bt3kb9NrPgD5wtm
         aBGFdqfy2UWqLGii5S8duD1uavmyEqX1qTmGb0J03M34oOUFDBQyJZA9ygxGIY3etohj
         SQSeL/AUivYOzauvL9huDn3jfTB5SB+VQTKLlZcK8o0JGumEivrOQdj6MOww7C/+tqy3
         jtYKypj3Yn34k1ANC8gsAubNPPEitL9Bvgtb9VUIsglkuFWhFYfyXO7nPya7vGpgluqV
         e8MQ13/QZWQ+eH74+H8UL3If5TQG3lMCRhsqhdk25hbP6rrusn8tvIsnJ+eZf8njv9ib
         B8sg==
X-Gm-Message-State: AOAM531Oof/kFtPdeDmEm5fBwQ99bUd2CsIxUJ2zTLlHf0Pqg3BlufkH
        YMNqPMkBYU5TiSQJfqoMy3w=
X-Google-Smtp-Source: ABdhPJx008we0suetDGoUE54YabAT5QLN1rrIL0tIRmHqKFJKX1NLepEg8losfM2AtGXeC3sZkmMlQ==
X-Received: by 2002:a6b:91d4:: with SMTP id t203mr2079141iod.149.1592438623025;
        Wed, 17 Jun 2020 17:03:43 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p9sm600391ile.87.2020.06.17.17.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 17:03:42 -0700 (PDT)
Date:   Wed, 17 Jun 2020 17:03:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>, daniel@iogearbox.net,
        alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <5eeaaf571cd75_38b82b28075185c4ea@john-XPS-13-9370.notmuch>
In-Reply-To: <20200617110217.35669-3-zeil@yandex-team.ru>
References: <20200617110217.35669-1-zeil@yandex-team.ru>
 <20200617110217.35669-3-zeil@yandex-team.ru>
Subject: RE: [PATCH bpf-next v4 3/3] bpf: add SO_KEEPALIVE and related options
 to bpf_setsockopt
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Yakunin wrote:
> This patch adds support of SO_KEEPALIVE flag and TCP related options
> to bpf_setsockopt() routine. This is helpful if we want to enable or tune
> TCP keepalive for applications which don't do it in the userspace code.
> 
> v2:
>   - update kernel-doc (Nikita Vetoshkin <nekto0n@yandex-team.ru>)
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
