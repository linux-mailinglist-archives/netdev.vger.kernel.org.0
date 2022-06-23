Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F34E557E79
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 17:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiFWPMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 11:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiFWPMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 11:12:22 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A926B15826
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 08:12:21 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id p8so25672469oip.8
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 08:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QRxoNIOb5DGaPivKLckHS+V/twyxJ7QI0MqIMyKFHG4=;
        b=zTnNbHHihzt3uYQ8YgNfbAz2qExArpOdV4cQ9VSOgxHD02k7cLsWh4SfIc3fRnwp/Y
         Gwp51++LG7Y0kxeP4EuGlH751v3xKt3+fKH0ESvG06KSQlZLIsoWZHKQlSW+wAa3TAYS
         KoF2CzzPHeYnnl2mF4A5PBcuMkkGqxML5c/4DlrzFHlmfVl0LhZyHmE7utoBjBAzCuHn
         P7FtQcFtHlJAnRr8zRfYNIxXywp6j19ILPqezj2iNq/2lwHA/1hsSpEYR7lIK/4P7uPH
         FeC+rXROBbDGSGaebhi0oIGEFOJYKuOjkNYes/DZWUaUZHlbziQk5mcn9fqqNTB/9f4s
         fpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QRxoNIOb5DGaPivKLckHS+V/twyxJ7QI0MqIMyKFHG4=;
        b=CDAQvqn7YfkGa6GkR850huu4kF/zblic+nsCbgmqJu2Z2ZrPFBmwbOu6CohCOcHWMq
         y4/YhmcojPE/7aseExF94KiVh1vAcx5uODz6bt9CaFI466osU/U7NX9zB8tp3NkxBzrE
         FNIOSL0J0wmMhX//aycZb8G+D23yKYYBg5jyqW9XS4ANsQ6BRvzGEeSolVMKNsm9LUqH
         ogtIwHzewGX8ni1ymk3o7533ha1D+bqcSY15DE95ssZ4QMglp33BpjY1YdG3uh0SJAXe
         r0KMQKoQI7CPhI/DhStBTVpNbALLBaR1Y/1a1QkGNdb6353ZDVKRqIg8Jmjv0n4z9ehh
         nIsQ==
X-Gm-Message-State: AJIora9zKPB3rA4r59DKpfIrTLhZKhvqnedrf6vutVP6CXqpSlhmm1wr
        ARpxjjsA73GyUFLDKix8vNWVTZob5CR0ACbqhG3SRCp9nBOt0w==
X-Google-Smtp-Source: AGRyM1vxtRjOlAFkE3XmeWB0Tvpz3YVFfAC9fgkAfl7gXzvCQYe2/6Uq6XnHmaO5GLWirPThEiZc+iIzGP7il6qsOg0=
X-Received: by 2002:a05:6808:1444:b0:32f:1e22:55d9 with SMTP id
 x4-20020a056808144400b0032f1e2255d9mr2491668oiv.106.1655997140976; Thu, 23
 Jun 2022 08:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220623140742.684043-1-victor@mojatatu.com> <20220623140742.684043-3-victor@mojatatu.com>
In-Reply-To: <20220623140742.684043-3-victor@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 23 Jun 2022 11:12:10 -0400
Message-ID: <CAM0EoM=tcS8LhED56O_r8pDosB8xp6v-tvDNOSZedU+dfn+wdw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] selftests: tc-testing: Add testcases to test new
 flush behaviour
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 10:08 AM Victor Nogueira <victor@mojatatu.com> wrote:
>
> Add tdc test cases to verify new flush behaviour is correct, which do
> the following:
>
> - Try to flush only one action which is being referenced by a filter
> - Try to flush three actions where the last one (index 3) is being
>   referenced by a filter
>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>

Looks good - small comment: Not sure it belongs to net or net-next.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
