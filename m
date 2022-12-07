Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30170645A79
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiLGNKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiLGNKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:10:47 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0121C56543
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:10:45 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id x22so13810540ejs.11
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ou3Fk2Irg7eK6b3UgZwKC8kZv42UyPRCF5b6cACD0ek=;
        b=EOcoZ2gqOYri3OdNf2eWcBugPym4istQe0643ZN2qwHGnqbETuuiTVNmINAfKvTCAq
         +bDAXaLNv7TsiPwYbOLR2UJBEm9gFa9eXl+NP+KWr5NaS/hUrKHZMfHBRQBaseneJRL8
         yJLmPKL3nt4+fS0kqHPKwIqyN1kXr8OQCEjjcrslq9b331+DsFCgwFxsSaiTzGGUuJzN
         qVLohUxswngg5r4Px4ggawMda66lbEyfSz3BDmQQ5j6XAiOVHtfv3TDLToZNUkGFI21L
         zEHiHNG17eoWeLIZdp1VUcwGX2Z/31FqfO/t7QXvC793WwnmWVDX0+TzAPvd0i+fxtw2
         eaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ou3Fk2Irg7eK6b3UgZwKC8kZv42UyPRCF5b6cACD0ek=;
        b=iktguCycWSe5UvnPH5GdQGuxWprnZ2ZjXytZgqN0qbEblgWjYOZU0nfdSdY21g8+Su
         lML+QPp1kug84rl0zSqYpub9pqmo0Lx7Dg1PRCiM8HuOI8jIVve+OqhW756vdHbpPzcI
         F9Xi5i232M0Lwo4Z9j/fa3Jwkp4K0wZG/z3xh3albdEkpFLqhYDIrwznbvdR7pLGWrt3
         zpQmc7koKwA7wHenytgTKBw/Qy7jwTWwBOktHpujfUSJUoSCVf1Env7ouBRE3F1PXSoO
         06uZwlnxg/BVqAKw5hSyezg0lVNvh7oP35NDCB9dmhwEweZeuIeH0CN0zp8v2GMUqfU/
         z0wg==
X-Gm-Message-State: ANoB5pnQlMxxDF+vyc+Wj9KGTV3rwxRphrqV31HOt0YzqDlJJFdH3JXT
        Hj2EXlSJgef+FP6af/VPrYILHg==
X-Google-Smtp-Source: AA0mqf4C2loeS6wG8nSTXbNYNX13ovAzfSYxgB9gpooa66WdeXRavQ7+9LKyrDQmomGPeGEgLzuLaQ==
X-Received: by 2002:a17:906:bc4a:b0:7c0:eb36:5225 with SMTP id s10-20020a170906bc4a00b007c0eb365225mr12713164ejv.229.1670418644424;
        Wed, 07 Dec 2022 05:10:44 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r1-20020a1709061ba100b00779a605c777sm8488129ejg.192.2022.12.07.05.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:10:43 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:10:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y5CQ0qddxuUQg8R8@nanopsycho>
References: <Y4eGxb2i7uwdkh1T@nanopsycho>
 <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4nyBwNPjuJFB5Km@nanopsycho>
 <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4okm5TrBj+JAJrV@nanopsycho>
 <20221202212206.3619bd5f@kernel.org>
 <Y43IpIQ3C0vGzHQW@nanopsycho>
 <20221205161933.663ea611@kernel.org>
 <Y48CS98KYCMJS9uM@nanopsycho>
 <20221206092705.108ded86@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206092705.108ded86@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 06:27:05PM CET, kuba@kernel.org wrote:
>On Tue, 6 Dec 2022 09:50:19 +0100 Jiri Pirko wrote:
>>> Yeah, that's a slightly tricky one. We'd probably need some form 
>>> of second order association. Easiest if we link it to a devlink
>>> instance, I reckon. The OCP clock card does not have netdevs so we
>>> can't follow the namespace of netdevs (which would be the second
>>> option).  
>> 
>> Why do we need this association at all?
>
>Someone someday may want netns delegation and if we don't have the
>support from the start we may break backward compat introducing it.

Hmm. Can you imagine a usecase?

Link to devlink instance btw might be a problem. In case of mlx5, one
dpll instance is going to be created for 2 (or more) PFs. 1 per ConnectX
ASIC as there is only 1 clock there. And PF devlinks can come and go,
does not make sense to link it to any of them.

Thinking about it a bit more, DPLL itself has no network notion. The
special case is SyncE pin, which is linked to netdevice. Just a small
part of dpll device. And the netdevice already has notion of netns.
Isn't that enough?
