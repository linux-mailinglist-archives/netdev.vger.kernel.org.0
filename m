Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D069E6C2673
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 01:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCUAso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 20:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCUAsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 20:48:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D735EFB8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:48:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so14511513pjp.1
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1679359722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdgphQPiN1nDc5Om0zpNZDCetCUSQ5OqCdbYegrSoyo=;
        b=c4bfvamElohAf/pkG3oSnnZ2G0iDWn77i2EP8Nl/KXTOimEd0sRgCeoCj3K1QD5266
         42MsngC7nCC58bal1ZC0QAQsZvk0G5S5zv22f7HbsClPVuQEd0j/Api2WX7rxy/t6D5k
         vOEDk1piYRcLZ976a7OYdiVb03VKgO2IdKDChoivZWfzfIQO9LtDQneOAL4CgwRIie9a
         CuCkhReRGkkECwJpf+oXZnxpRrlP4JcuPEHQaUijlMhTtTp0m7PevVF7sAalo0YbaDdo
         B7RlqWPE6A+InMTh4/9JqLUfZi9l4J/70U8+w3Lk2ZUjbzCsePB/E8/fchbYMNvcZrY6
         Uf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679359722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HdgphQPiN1nDc5Om0zpNZDCetCUSQ5OqCdbYegrSoyo=;
        b=KCJcbifPEVm3H6T0IBI63xjC0J6Y9GEmitpCmxjsAZOdfg6CYsaHcq0LfA4jz3RQNh
         XXfL/d1dwT68P+P0sQ84klST5dVXekOgRq+YkaiR+lcxUM8fEX69sQh+6MvBYo76+HF3
         x6o7W9z4yIxWVLD19XtaCKhgX0aRE+mMQN3x7m9S5MmC+0JjrWp7K9wKV+JGdao/BJRk
         CoWA/hIQOq5CurSgN6Ohz2ywvOy2z1hF5mdVBZZ+GMYDIeVjc1c60zAGemV9bvDK9v81
         qgcZZr9i5H3v0M5Q1eDW4oKnaxtbKLmbJ1/AbGUJ5pZVe2JEZrYXA3s2FS4iOqWmL4oy
         wp8w==
X-Gm-Message-State: AO0yUKV49g2A1eeVPcuJ4dXXRDF71FIIrMi1rIxbBH3eH5e923KX6nt1
        dWk73MtsfWdoR8y5wN3oPBZv1Q==
X-Google-Smtp-Source: AK7set+SNNkatnUrPtylad8ioYjMrZkoKZaT47BRgbvh/ivP+e4GpYCXZ7wj8fCAG6Dt00nfq1YjZg==
X-Received: by 2002:a17:902:d18a:b0:1a0:6852:16dd with SMTP id m10-20020a170902d18a00b001a0685216ddmr322160plb.12.1679359721957;
        Mon, 20 Mar 2023 17:48:41 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b00198d7b52eefsm7239906plk.257.2023.03.20.17.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 17:48:41 -0700 (PDT)
Date:   Mon, 20 Mar 2023 17:48:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230320174840.4db888eb@hermes.local>
In-Reply-To: <20230320170221.27896adb@kernel.org>
References: <20230315223044.471002-1-kuba@kernel.org>
        <8da9b24b-966a-0334-d322-269b103f7550@gmail.com>
        <20230320170221.27896adb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 17:02:21 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 16 Mar 2023 16:16:39 -0700 Florian Fainelli wrote:
> > Did it not stand for New API?  
> 
> I think it did. But we had extra 20 years of software development
> experience and now agree that naming things "new" or "next" is
> a bad idea? So let's pretend it stands for nothing. Or NAPI API ;)


Maybe just a footnote like:
  [1] Was originally referred to as New API in 2.4 Linux.
