Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45565E973
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjAEK76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbjAEK7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:59:40 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9E957907;
        Thu,  5 Jan 2023 02:59:30 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id az7so11325504wrb.5;
        Thu, 05 Jan 2023 02:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wxg4n9JP4gJD7PKhSiNfZm9HcsyJiX7nt/oNFVx3d0s=;
        b=IogR2t2gkZFtz//KdpYY+adNeEuq7UdJSkjO6nCOkAzu1atSQsKciiH5hiVlXxnHR+
         MmrTYUex+/Sr59FIioxlYp81SFIIqACUrOG7shjmyOUnk68UKWAx708gobvhtgSnqZLV
         KI4ck1NOo/qE2y/SR0OzPM4E7nFvSt8eeOwkW7kfviBU6aBIm0XuxvFuTdY26a9exi80
         nZfpi/OqHJnQmVs+iltP+xl+rirdERCd3v4BxSjm6PQC2ZxbkdPGx6Xh1t+QS9HcP2XE
         QiafpN1rBxcrEhwIywUy6PMkrgnbDPjMQM0VChkmN2q40xTFr1ULbXxNxFmXrIVUrdVi
         R9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wxg4n9JP4gJD7PKhSiNfZm9HcsyJiX7nt/oNFVx3d0s=;
        b=MhL4p+hBK8LKnJrLVIsw/H41ee2qN4uEFEBLPKbOJWXyS5/L9gORuED3gIdyx0eEmS
         mkJVKgqq621gkCUSNkMElrfkCTb47mG/MwKDKGXuDeg5iLZBfAEg5pcdX+nihBMlgVHP
         ceSjxGiwdfdUIvAnbR6am5AkfBvf6/NFcn12LSXnkBX1cB7fQMdqQU2nlRzYCsKceV3w
         mw0jJb/REWrxiAO53wP+PwBdWOGI1c3b6+5w7iqdNhD/d05OsXqsxQe+UpHzFWGiYwVk
         4XZMGcRHV9H5zbCRx6qRJiRjXjO1lrbqA1NlKkpkuDbonT9hiEb1gZIsOea0CKNQfu0v
         3/tg==
X-Gm-Message-State: AFqh2koaw9iZGezkATdBOkod7If/GZyrc8lJuKZGVfT4OgNKaxYEsaQL
        dsSru2K6f6pjNR3My5nVr2k=
X-Google-Smtp-Source: AMrXdXtYwh5O+rYA9+7GVMmmJIKoPK/pGHeSNjC1fUIzIxedgu9At+LnqH/M8jguOESETkxHzlrVlg==
X-Received: by 2002:adf:f0ca:0:b0:275:e426:4134 with SMTP id x10-20020adff0ca000000b00275e4264134mr27976450wro.51.1672916369161;
        Thu, 05 Jan 2023 02:59:29 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c11-20020a5d4ccb000000b002b6bcc0b64dsm126541wrt.4.2023.01.05.02.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:59:28 -0800 (PST)
Date:   Thu, 5 Jan 2023 13:58:20 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next 2/8] net: microchip: sparx5: Reset VCAP counter
 for new rules
Message-ID: <Y7atTB9r07M+ZUC0@kadam>
References: <20230105081335.1261636-1-steen.hegelund@microchip.com>
 <20230105081335.1261636-3-steen.hegelund@microchip.com>
 <Y7aT8xGOCfvC/U0a@kadam>
 <7fa8ea30beffcb9256422f7a474a8be7d5791f5a.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fa8ea30beffcb9256422f7a474a8be7d5791f5a.camel@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Email re-arranged because I screwed up - dan]

On Thu, Jan 05, 2023 at 11:43:17AM +0100, Steen Hegelund wrote:

> This series was first sent to net, but the response was that I should go into
> net-next instead, so it is really a first version in net-next.
> 
> What was your question?  I was not able to find it...

Ugh...  Oauth2 code (mutt/msmtp) silently ate my email.  Sorry.

> > > @@ -1833,6 +1834,8 @@ int vcap_add_rule(struct vcap_rule *rule)
> > >       ret = vcap_write_rule(ri);
> > >       if (ret)
> > >               pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__,
> > > ret);

There should be a "goto out;" after the pr_err().

> > > +     /* Set the counter to zero */
> > > +     ret = vcap_write_counter(ri, &ctr);
> > >  out:
> > >       mutex_unlock(&ri->admin->lock);
> > >       return ret;
> > 

regards,
dan carpenter

