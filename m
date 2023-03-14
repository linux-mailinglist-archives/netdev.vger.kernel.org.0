Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A589E6B95E5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjCNNTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjCNNSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:18:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF519000;
        Tue, 14 Mar 2023 06:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A30C961773;
        Tue, 14 Mar 2023 13:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0021FC433EF;
        Tue, 14 Mar 2023 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678799698;
        bh=d77Zybmz4sMXlH9Uze1IGl0BLqEQ0muIDiBx2/KvyFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s3P9qxlj3N/eljo6oOWlngBZnv9pJ0zX3qrjpuGGatfcUK7gG6TVlKD3w/sUeEHy6
         a9o7KvJvc9k2AZywk6SYJl3TurpHS+NtbNIF8RFpd2bDUPB4Fy90E6NblP0cyiVdH2
         up5o+6+m2lwHPFPr26CZSEjmq5yoDDM7v2mZ8Q4qrvvAUi6PGNIx5ss5usxFk+fp44
         4N2RdZxMTPRGzaUS9e5Xr17UJ3maWlhFYaSPkjKBoqkFE7z5c9NqgKI64wua62D/SJ
         dbx+X2mTP1qazBFTO+hi48ZyGeSIQmOzGluViHzmarrvjEJKO2+0uEcF2aAnmvAVVF
         neqpIOyXd3n2g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pc4VU-0007QP-Ei; Tue, 14 Mar 2023 14:16:01 +0100
Date:   Tue, 14 Mar 2023 14:16:00 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Message-ID: <ZBBzkMd0hHYOz8Vd@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-3-steev@kali.org>
 <ZAoS1T9m1lI21Cvn@hovoldconsulting.com>
 <CAKXuJqhEKB7cuVhEzObbFyYHyKj87M8iWVaoz7gkhS2OQ9tTBA@mail.gmail.com>
 <ZArb/ZQEmfGDjYyc@hovoldconsulting.com>
 <CAKXuJqhe3z0XrLCMZ3vc3+Ug-rMjayNuMAvh+ucuUkZQpQdb2A@mail.gmail.com>
 <ZBBP/S8OM0t6p57E@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBBP/S8OM0t6p57E@hovoldconsulting.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:44:14AM +0100, Johan Hovold wrote:
> On Sun, Mar 12, 2023 at 10:18:48PM -0500, Steev Klimaszewski wrote:

> > Works, but, not quite well, and with the nvm bits from Tim's patch, we
> > end up getting closer?  I think that is the best way to put it.  With
> > what we currently have, we end up loading hpnv21.bin for our nvm patch
> > file, however, we actually want (at least on my Thinkpad X13s) the
> > .b8c file from the Windows partition for our nvm patch; With the b8c
> > file symlinked to .bin with just my patch set, I am able to connect a
> > pair of Air Pods Gen1 to the ThinkPad and play back audio, as well as
> > use them for input.  With the .bin file that comes from
> > linux-firmware, they will still connect, however, they will randomly
> > disconnect, as well as the audio output is all garbled.
> 
> Hmm. Ok, but then we need to ask Lenovo and Qualcomm to release the
> firmware files we need for the X13s. Until then using your patch and
> "hpnv21.bin" at least works to some extent.
> 
> I could connect to one bluetooth speaker without noticing any problems,
> but I did indeed get some garbled output when connecting to another. I
> have not tried the .b8c file yet though, so this could possibly be some
> other incompatibility issue.

I just tried with the hpnv21.b8c from the (somewhat old) windows
installation on my x13s, but the bluetooth speaker that produced garbled
output with the firmware from linux-firmware still does so with the
windows file.

Johan
