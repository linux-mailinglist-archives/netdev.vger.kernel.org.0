Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD87620EC7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiKHLXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbiKHLXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:23:10 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240834877B;
        Tue,  8 Nov 2022 03:23:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v27so21976096eda.1;
        Tue, 08 Nov 2022 03:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2+psZjXySrgWO95sAydADMN8XzzN9c04wfmCKnTPkHo=;
        b=NwtOy3YR6NL0Rp3dNnPZkVN3BHTomN749KfBM4MICWmtT5C4qlqS3f54WfPuC5iYEE
         XykaZFNJLBQ/R9TlH9wDjLQLDO0nF1R0R/erBlS1CKQ6LWO1T6iHsUwRq0ijG7P97qQS
         uQBC1C0Q/34yIMDv/7LFQXxVkszyrs+raYEf1P0umX9OShXuVx5BJI15nBX9m7AAuJhn
         Qtlp+sCq8yNBhFtmHqqbcCf7uHjFCbkVEabMotC8piMJbJdqRrPif4P4LvOE9UjTCB4W
         j2KbchsI/m5BD78tJidjwo5UhgEZmsEQwaotHFVsmQpLz/oTOmXNkxCUrEWLlPSvaWWx
         Z+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+psZjXySrgWO95sAydADMN8XzzN9c04wfmCKnTPkHo=;
        b=Gw2e8op6F9nELu0h0UD0dLHF8PzcQMfYOs705v7hqGohnlIbajStuMOIL+b2pEt+J6
         RPgVzjnY6qh71g0rbYnAeHGkGMdo0vzHNGczyDiN6EepzX4ByRBBslcWmmRWiojQPjR6
         5Q5bQfmJB1sXOgmOJAv3mLge8drnNnUMAiFaUR1YW77YcNfrArWS/3BTjn0XBOgJ3Brx
         zo4NcFxPYNr4PadM6gP1MEaCSzqdegJIstQpkRvU4aqHn5yrLb9izuXzCdf4m1Bkn4bU
         Xllu4/bc42+kFj8NN+ouGicxa3+rX9m+KiNQWEzsJ4OpwByG3R9pxy+5h3C20JXdLjJb
         Zzqg==
X-Gm-Message-State: ACrzQf21+8SSKweakdicKSUgciO+k0GQ3mFCGgb6nGdg9nA5lzP3U98r
        UTR2ziUD566shPELxxcJrwk=
X-Google-Smtp-Source: AMsMyM7gHlj9h4Gh9dmKct0Va3BWJOL5SuW55xdomHkNTfeuCgKGa+Sntm9RafdyNAuICSXtFsLivA==
X-Received: by 2002:a05:6402:4444:b0:458:f355:ce04 with SMTP id o4-20020a056402444400b00458f355ce04mr56213467edb.422.1667906587567;
        Tue, 08 Nov 2022 03:23:07 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709063e5200b007a62215eb4esm4608547eji.16.2022.11.08.03.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 03:23:07 -0800 (PST)
Date:   Tue, 8 Nov 2022 13:23:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Message-ID: <20221108112305.bkdxezogmymhmaei@skbuf>
References: <20221108090039.imamht5iyh2bbbnl@skbuf>
 <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
 <20221108094018.6cspe3mkh3hakxpd@skbuf>
 <a9109da1-ba49-d8f4-1315-278e5c890b99@nbd.name>
 <20221108100851.tl5aqhmbc5altdwv@skbuf>
 <5dbfa404-ec02-ac41-8c9b-55f8dfb7800a@nbd.name>
 <20221108103330.xt6wi3x3ugp7bbih@skbuf>
 <1be4d21b-c0a4-e136-ed68-c96470135f14@nbd.name>
 <20221108105237.v4coebbj7kzee7y6@skbuf>
 <75932a98-0f9b-0cda-c1dc-29322bc0141b@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75932a98-0f9b-0cda-c1dc-29322bc0141b@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:56:52AM +0100, Felix Fietkau wrote:
> On 08.11.22 11:52, Vladimir Oltean wrote:
> > On Tue, Nov 08, 2022 at 11:42:09AM +0100, Felix Fietkau wrote:
> > > Okay, I will stick with METADATA_HW_PORT_MUX for now. If we use it in the
> > > flow dissector to avoid the tagger specific fixup, we might as well use it
> > > in DSA to skip the tag proto receive call. What do you think?
> > 
> > I suppose that dsa_switch_rcv() could test for the presence of a metadata_dst
> > and treat that generically if present, without unnecessarily calling down into
> > the tagging protocol ->rcv() call. The assumption being that the metadata_dst
> > is always formatted (by the DSA master) in a vendor-agnostic way.
> 
> Right. The assumption is that if we use METADATA_HW_PORT_MUX, the field
> md_dst->u.port_info.port_id will contain the index of the DSA port.

Yes. Please coordinate with Maxime, see if it's possible to do something
similar (generic) on TX, depending on whether the DSA master reports it
can interpret metadata_dst as offloaded DSA tags. You didn't copy too
many folks to this patch set, so others might have missed it.
