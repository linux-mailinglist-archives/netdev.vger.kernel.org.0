Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B666DFE8E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjDLTQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjDLTQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:16:28 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAF15BB1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 12:16:26 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id o7so9331604qvs.0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 12:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681326986; x=1683918986;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8TIJD5LOWJoz6EIfTWXTXASfah5FIQENoashRRU1aro=;
        b=M+BjzxG553ZBjq8mtiyNoajDNqZpFXViO4gQ8yBn4sc+NRWz7YP3557PuAOwxMk6GE
         fjpppo85O7HPbMrpiGBTj112KF8Gn5KHq5bWZjk4g+tR8TLBLo3KDP7HKyNUJdqx0JPs
         n9Wx2V3eUYB0LznDuJ4Lah6hQp/cNh0feppy1kwo7Ndl6ku+sHno2PbjuQDeMbUtdMye
         2lnrWR/DcDeyD3Ky8BtQD69yVvVEUxPDzY4LqWL+T2eyRa3wxf/zvv0yHw2Rb3Br4uSG
         RuGpo8EC2rBiwrwocvrqIRpz7es7SRFNhkpFcv1qJZdWqTzYYicH7UPFdtJz12Imh82r
         fkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681326986; x=1683918986;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8TIJD5LOWJoz6EIfTWXTXASfah5FIQENoashRRU1aro=;
        b=V/Xm2TODKjabWFNASNzDCRPETHkYI1+59Mi7D2D4XU3NUFcfBBlwxVNusrLABOi9Jj
         wfE8GLE+sgPYndn5PkJVhj7c1oGVh4sA3vsPMQDm2RxYf0A1mIF1HkI5QesJuf8AnQ1x
         rRd371jusVASAg+u8dm5Bhepm8DBRH2JANTbMlzJvkOga0rdHRhHXamVECZEosvPgqk/
         ssyhHLpV1y6Gubjzr139KE5ZKhNA3DOXPynO/W3OlUhnByud3XWNHoD5CApXzosDizFB
         qCjMFBXtBzn8iuY0u/PBdCDzcwPMVuc3KeiukBS8MlFaRT6wI6TSr1GvbiLGACyO325C
         eQ9Q==
X-Gm-Message-State: AAQBX9dRYyb8w4Ryb3xfNC1Je/6umPsR3x7ZI70Jn7uuB5ojFbYMxcNa
        x3DM4u+gj6W2PkR8hb/lDnM=
X-Google-Smtp-Source: AKy350Y0h9efYDQHPz1Cy7hvMBwrgRrnqwJPu8h7jgTGY00HL+W20iWmEJswDjsskIMtmNPysLBPGw==
X-Received: by 2002:a05:6214:519a:b0:5db:4e49:b2bd with SMTP id kl26-20020a056214519a00b005db4e49b2bdmr4747725qvb.18.1681326985851;
        Wed, 12 Apr 2023 12:16:25 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id o2-20020a0cfa82000000b005e8d802ce32sm53791qvn.143.2023.04.12.12.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 12:16:25 -0700 (PDT)
Date:   Wed, 12 Apr 2023 15:16:25 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Sasha Levin <sashal@kernel.org>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, willemb@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org, decot@google.com,
        davem@davemloft.net
Message-ID: <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
In-Reply-To: <ZDb3rBo8iOlTzKRd@sashalap>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <ZDb3rBo8iOlTzKRd@sashalap>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel IDPF
 driver
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sasha Levin wrote:
> On Mon, Apr 10, 2023 at 06:13:39PM -0700, Pavan Kumar Linga wrote:
> >v1 --> v2: link [1]
> > * removed the OASIS reference in the commit message to make it clear
> >   that this is an Intel vendor specific driver
> 
> How will this work when the OASIS driver is ready down the road?
> 
> We'll end up with two "idpf" drivers, where one will work with hardware
> that is not fully spec compliant using this Intel driver, and everything
> else will use the OASIS driver?
> 
> Does Intel plan to remove this driver when the OASIS one lands?
> 
> At the very least, having two "idpf" drivers will be very confusing.

One approach is that when the OASIS v1 spec is published, this driver
is updated to match that and moved out of the intel directory.

This IPU/DPU/SmartNIC/.. device highly programmable. I assume a goal
is to make sure that the device meets the new v1 spec. That quite
likely requires a firmware update, but that is fine.
