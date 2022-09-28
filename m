Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4321F5ED4F2
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiI1GhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiI1GhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:37:11 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542899F0E2
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:37:07 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w2so11737187pfb.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=gtMbsQdrkXrdSK+9ZBU1nddAaTCHY9MtYZDHuUmps0o=;
        b=E8MupokRE7VmpCdQpCJBAYTrS53w5zyNRJCXn9kPVwFRLVGhSIiA+AVz94aeK8XYU6
         w5euHEpllqiWNaWVDXiExyrPfqxl6pFo5TsxuNaOIN7M02xUM5WwYhAv4mTGxnc1/0DA
         6NMeWZaYSmjJTVbiZicXa9DaWJLleYUxMYD/8p+F9U4yNhvlAojceAFqZLt89j7ICIGB
         jB4OTDXyZebKnU10Pb6NRMrnaw+3rlzQmUGPDpOX9k5sgqRnm3DAC1hu1dipnnvCDxGx
         XHMCpY5+7usX4nNqe+0q8678Sm1rzEz6oUNeplOGmB79OzOAbUldsH4gUjMxhYVx1DSg
         erjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=gtMbsQdrkXrdSK+9ZBU1nddAaTCHY9MtYZDHuUmps0o=;
        b=xp6Uz3Bd/jimL4+McPnbjeTEFI1B2lgmLN4Mv9tYiAgAXp0ZX9p/f/m3lh1ZqdRD56
         saLqtBJxC7jS9cnANVlubnJs/Pp9HBHokVn7n+Rn9leA5COZKPnlGV0kO003BayHkjng
         9SFxJ8JVxzdCzaxWi8wocckwBE0LSZSjNys+itWK5uBuK65uXRbzI8Kj1HWGKLFbVWoz
         p6ZR9bbXACS98/Lp4QKhA8IWY7qgfjO1L8X4o6CUUQ7MPGyG6O3ubUg+S7kXHYJtfj2e
         OuGHqCJWH8+m5vqlHdHkyXBFtSCB2pnJQTVk22zu8FbX7xH46JwoPb7q4PqQYwNn40kn
         WZcg==
X-Gm-Message-State: ACrzQf221Ue3Ov1df43hxAqOFBiMOZnzW4ivHAG4xfYbCOZGOQu3W27N
        8GL54XdnMpkZD7cD02oYGpxDRw9Ai1MEkg==
X-Google-Smtp-Source: AMsMyM6IiHp2XNOTZhUcP3VNoR+3Ot13DstUJDtxLn0igyg+CYw6OKZbhZER3X+mBTrZezLWQzKooA==
X-Received: by 2002:a65:408b:0:b0:42a:55fb:60b0 with SMTP id t11-20020a65408b000000b0042a55fb60b0mr28035702pgp.431.1664347026921;
        Tue, 27 Sep 2022 23:37:06 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id oa15-20020a17090b1bcf00b00205db4ff6dfsm644812pjb.46.2022.09.27.23.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 23:37:06 -0700 (PDT)
Date:   Wed, 28 Sep 2022 14:37:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Message-ID: <YzPrjj0h0o0Imsvy@Laptop-X1>
References: <20220923042000.602250-1-liuhangbin@gmail.com>
 <115c54d7-87fc-2c50-bc27-ad7cdb27bb2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <115c54d7-87fc-2c50-bc27-ad7cdb27bb2c@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, Sep 27, 2022 at 09:12:35PM -0600, David Ahern wrote:
> >  
> > -	if (echo_request)
> > -		ret = rtnl_talk(&rth, &req.n, &answer);
> > -	else
> > -		ret = rtnl_talk(&rth, &req.n, NULL);
> > -
> > -	if (ret < 0)
> > -		return -2;
> > -
> > -	if (echo_request) {
> > -		new_json_obj(json);
> > -		open_json_object(NULL);
> > -		print_addrinfo(answer, stdout);
> > -		close_json_object();
> > -		delete_json_obj();
> > -		free(answer);
> > -	}
> > -
> > -	return 0;
> > +	return rtnl_echo_talk(&rth, &req.n, print_addrinfo);
> 
> I was thinking something more like:
> 
> if (echo_request)
> 	return rtnl_echo_talk(&rth, &req.n, print_addrinfo);
> 
> return rtnl_talk(&rth, &req.n, NULL);

OK, I will update the patch. I have one question about the return value.
In previous code, the function return -2 if rtnl_talk() fails. I don't know
why we use "-2" here. And you suggested to just return rtnl_talk() directly.

Does this means we can ignore the -2 return values for all the places safely,
and just return rtnl_talk()?

Thanks
Hangbin
