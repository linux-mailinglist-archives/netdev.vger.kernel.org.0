Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A753E17B569
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 05:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCFE2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 23:28:38 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33584 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgCFE2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 23:28:37 -0500
Received: by mail-yw1-f65.google.com with SMTP id j186so1128409ywe.0
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 20:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBOHwsMv/HnuybNyOaAqPfh53GkcJWptiQX+bb5jgmg=;
        b=C5AVNXNsDOIOYpkPwqGWLvSXZgrCG0N5pXWaKuNf+jfB/I+X0A4EhiYftdov4lZ8Nq
         HwRocRXutIMpWGgdjpvXXL9H83ppclw7tcposUTB0onY8uFALG4YLJdKNsmjrPjoZK/S
         ZRefxB7zE1AbFSCv17r7UKqYz4OlkRBWBDxWXjMM/BimTJgp5KcZ0qb4D6qmyxU5jEiG
         p2gipPOXQpUu7vyWsnAWSn44sj6L8GkAE94H2gA5MWvSvJCZZskHt/ODHCtCkuYZXR2q
         at8n4afogG9hKPNflA3fiMFfViiCSMc4gW7/Rzrq2qM+PeIGTG2hc6va7c4fax/uOG+1
         KqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBOHwsMv/HnuybNyOaAqPfh53GkcJWptiQX+bb5jgmg=;
        b=QudWG8pqCuIEX6YFEurRi2V1f1BE8KeJ5Nsyv8ugnoWatc9DE4SnYZ9l/NWD1CWpZI
         bYGnHq8DQcFTHXhu1mxpMdt3LER7QDYMq5JrUNHkukN4nDcI1PBLm5Puw/6e2phw4AdJ
         VDKEYlx8K6loatNnz7Z1JdWiZYnmTc/YnMpf120Q7S1vGjPY7UkMXlNoG1G5+mKhuHgp
         WDQ0aHyDhODMWnqHw1XmwnS+RYFDOiv1LhcNspdThtTQRtTc1yx/QoqCNKwcHjzZtewU
         BapzGl2GNqLskLXeiXXFUMBICnmv5XV35K6GEXBM7jCMsExmSJdysEy0We0l4tT/b8JE
         JUnQ==
X-Gm-Message-State: ANhLgQ2UvkN0uBYB1VJ/er1wt+pH/uzeviEwXRbgSiZQz3YrPJQVHmJq
        /Fv2vo0lBlN8SM9Tcrodq+3hFg==
X-Google-Smtp-Source: ADFU+vu/+zbicS6mGfwIeKlASfFOshwP8HTQ4OoR5foKUaSrc8WIFtwNUclVpvWWScqtEnujz8ey3Q==
X-Received: by 2002:a25:3496:: with SMTP id b144mr1793102yba.356.1583468916167;
        Thu, 05 Mar 2020 20:28:36 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm12581836ywa.32.2020.03.05.20.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 20:28:35 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/17] net: introduce Qualcomm IPA driver (UPDATED)
Date:   Thu,  5 Mar 2020 22:28:14 -0600
Message-Id: <20200306042831.17827-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series presents the driver for the Qualcomm IP Accelerator (IPA).

This is version 2 of this updated series.  It includes the following
small changes since the previous version:
  - Now based on net-next instead of v5.6-rc
  - Config option now named CONFIG_QCOM_IPA
  - Some minor cleanup in the GSI code
  - Small change to replenish logic
  - No longer depends on remoteproc bug fixes
What follows is the basically same explanation as was posted previously.

					-Alex

I have posted earlier versions of this code previously, but it has
undergone quite a bit of development since the last time, so rather
than calling it "version 3" I'm just treating it as a new series
(indicating it's been updated in this message).  The fast/data path
is the same as before.  But the driver now (nearly) supports a
second platform, its transaction handling has been generalized
and improved, and modem activities are now handled in a more
unified way.

This series is available (based on net-next in branch "ipa_updated-v2"
in this git repository:
  https://git.linaro.org/people/alex.elder/linux.git

The branch depends on other one other small patch that I sent out
for review earlier.
  https://lore.kernel.org/lkml/20200306042302.17602-1-elder@linaro.org/


I want to address some of the discussion that arose last time.

First, there was the WWAN discussion.  Here's the history:
  - This was last posted nine months ago.
  - Reviewers at that time favored developing a new WWAN subsystem that
    would be used for managing devices like this.  And the suggestion
    was to not accept this driver until that could be developed.
  - Along the way, Apple acquired much of Intel's modem business.
    And as a result, the generic framework became less pressing.
  - I did participate in the WWAN subsystem design however, and
    although it went dormant for a while it's been resurrected:
      https://lore.kernel.org/netdev/20200225100053.16385-1-johannes@sipsolutions.net/
  - Unfortunately the proposed WWAN design was not an easy fit
    with Qualcomm's integrated modem interfaces.  Given that
    rmnet is a supported link type for in the upstream "iproute2"
    package (more on this below), I have opted not to integrate
    with any WWAN subsystem.

So in summary, this driver does not integrate with a generic WWAN
framework.  And I'd like it to be accepted upstream despite that.


Next, Arnd Bergmann had some concerns about flow control.  (Note:
some of my discussions with Arnd about this were offline.) The
overall architecture here also involves the "rmnet" driver:
  drivers/net/ethernet/qualcomm/rmnet

The rmnet driver presents a network device for use.  It connects
with another network device presented, by the IPA driver.  The
rmnet driver wraps (and unwraps) packets transferred to (and from)
the IPA driver with QMAP headers.

   ---------------
   | rmnet_data0 |    <-- "real" netdev
   ---------------
          ||       }- QMAP spoken here
   --------------
   | rmnet_ipa0 |     <-- also netdev, transporting QMAP packets
   --------------
          ||
   --------------
  ( IPA hardware )
   --------------

Arnd's concern was that the rmnet_data0 network device does not
have the benefit of information about the state of the underlying
IPA hardware in order to be effective in controlling TX flow.
The feared result is over-buffering of TX packets (bufferbloat).
I began working on some simple experiments to see whether (or how
much) his concern was warranted.  But it turned out that completing
these experiments was much more work than had been hoped.

The rmnet driver is present in the upstream kernel.  There is also
support for the rmnet link type in the upstream "ip" user space
command in the "iproute2" package.  Changing the layering of rmnet
over IPA likely involves deprecating the rmnet driver and its
support in "iproute2".  I would really rather not go down that
path.

There is precedent for this sort of layering of network devices
(L2TP, VLAN).  And any architecture like this would suffer the
issues Arnd mentioned; the problem is not limited to rmnet and IPA.
I do think this is a problem worth solving, but the prudent thing
to do might be to try to solve it more generally.

So to summarize on this issue, this driver does not attempt to
change the way the rmnet and IPA drivers work together.  And even
though I think Arnd's concerns warrant more investigation, I'd like
this driver to to be accepted upstream without any change to this
architecture.


Finally, a more technical description for the series, and some
acknowledgements to some people who contributed to it.

The IPA is a component present in some Qualcomm SoCs that allows
network functions such as aggregation, filtering, routing, and NAT
to be performed without active involvement of the main application
processor (AP).

In this initial patch series these advanced features are not
implemented.  The IPA driver simply provides a network interface
that makes the modem's LTE network available in Linux.  This initial
series supports only the Qualcomm SDM845 SoC.  The Qualcomm SC7180
SoC is partially supported, and support for other platforms will
follow.

This code is derived from a driver developed by Qualcomm.  A version
of the original source can be seen here:
  https://source.codeaurora.org/quic/la/kernel/msm-4.9/tree
in the "drivers/platform/msm/ipa" directory.  Many were involved in
developing this, but the following individuals deserve explicit
acknowledgement for their substantial contributions:

    Abhishek Choubey
    Ady Abraham
    Chaitanya Pratapa
    David Arinzon
    Ghanim Fodi
    Gidon Studinski
    Ravi Gummadidala
    Shihuan Liu
    Skylar Chang

					-Alex

Alex Elder (17):
  remoteproc: add IPA notification to q6v5 driver
  dt-bindings: soc: qcom: add IPA bindings
  soc: qcom: ipa: main code
  soc: qcom: ipa: configuration data
  soc: qcom: ipa: clocking, interrupts, and memory
  soc: qcom: ipa: GSI headers
  soc: qcom: ipa: the generic software interface
  soc: qcom: ipa: IPA interface to GSI
  soc: qcom: ipa: GSI transactions
  soc: qcom: ipa: IPA endpoints
  soc: qcom: ipa: filter and routing tables
  soc: qcom: ipa: immediate commands
  soc: qcom: ipa: modem and microcontroller
  soc: qcom: ipa: AP/modem communications
  soc: qcom: ipa: support build of IPA code
  MAINTAINERS: add entry for the Qualcomm IPA driver
  arm64: dts: sdm845: add IPA information

 .../devicetree/bindings/net/qcom,ipa.yaml     |  192 ++
 MAINTAINERS                                   |    6 +
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |   51 +
 drivers/net/Kconfig                           |    2 +
 drivers/net/Makefile                          |    1 +
 drivers/net/ipa/Kconfig                       |   19 +
 drivers/net/ipa/Makefile                      |   12 +
 drivers/net/ipa/gsi.c                         | 2055 +++++++++++++++++
 drivers/net/ipa/gsi.h                         |  257 +++
 drivers/net/ipa/gsi_private.h                 |  118 +
 drivers/net/ipa/gsi_reg.h                     |  417 ++++
 drivers/net/ipa/gsi_trans.c                   |  786 +++++++
 drivers/net/ipa/gsi_trans.h                   |  226 ++
 drivers/net/ipa/ipa.h                         |  148 ++
 drivers/net/ipa/ipa_clock.c                   |  313 +++
 drivers/net/ipa/ipa_clock.h                   |   53 +
 drivers/net/ipa/ipa_cmd.c                     |  680 ++++++
 drivers/net/ipa/ipa_cmd.h                     |  195 ++
 drivers/net/ipa/ipa_data-sc7180.c             |  307 +++
 drivers/net/ipa/ipa_data-sdm845.c             |  329 +++
 drivers/net/ipa/ipa_data.h                    |  280 +++
 drivers/net/ipa/ipa_endpoint.c                | 1707 ++++++++++++++
 drivers/net/ipa/ipa_endpoint.h                |  110 +
 drivers/net/ipa/ipa_gsi.c                     |   54 +
 drivers/net/ipa/ipa_gsi.h                     |   60 +
 drivers/net/ipa/ipa_interrupt.c               |  253 ++
 drivers/net/ipa/ipa_interrupt.h               |  117 +
 drivers/net/ipa/ipa_main.c                    |  954 ++++++++
 drivers/net/ipa/ipa_mem.c                     |  314 +++
 drivers/net/ipa/ipa_mem.h                     |   90 +
 drivers/net/ipa/ipa_modem.c                   |  383 +++
 drivers/net/ipa/ipa_modem.h                   |   31 +
 drivers/net/ipa/ipa_qmi.c                     |  538 +++++
 drivers/net/ipa/ipa_qmi.h                     |   41 +
 drivers/net/ipa/ipa_qmi_msg.c                 |  663 ++++++
 drivers/net/ipa/ipa_qmi_msg.h                 |  252 ++
 drivers/net/ipa/ipa_reg.c                     |   38 +
 drivers/net/ipa/ipa_reg.h                     |  476 ++++
 drivers/net/ipa/ipa_smp2p.c                   |  335 +++
 drivers/net/ipa/ipa_smp2p.h                   |   48 +
 drivers/net/ipa/ipa_table.c                   |  700 ++++++
 drivers/net/ipa/ipa_table.h                   |  103 +
 drivers/net/ipa/ipa_uc.c                      |  211 ++
 drivers/net/ipa/ipa_uc.h                      |   32 +
 drivers/net/ipa/ipa_version.h                 |   23 +
 drivers/remoteproc/Kconfig                    |    6 +
 drivers/remoteproc/Makefile                   |    1 +
 drivers/remoteproc/qcom_q6v5_ipa_notify.c     |   85 +
 drivers/remoteproc/qcom_q6v5_mss.c            |   38 +
 .../linux/remoteproc/qcom_q6v5_ipa_notify.h   |   82 +
 50 files changed, 14192 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipa.yaml
 create mode 100644 drivers/net/ipa/Kconfig
 create mode 100644 drivers/net/ipa/Makefile
 create mode 100644 drivers/net/ipa/gsi.c
 create mode 100644 drivers/net/ipa/gsi.h
 create mode 100644 drivers/net/ipa/gsi_private.h
 create mode 100644 drivers/net/ipa/gsi_reg.h
 create mode 100644 drivers/net/ipa/gsi_trans.c
 create mode 100644 drivers/net/ipa/gsi_trans.h
 create mode 100644 drivers/net/ipa/ipa.h
 create mode 100644 drivers/net/ipa/ipa_clock.c
 create mode 100644 drivers/net/ipa/ipa_clock.h
 create mode 100644 drivers/net/ipa/ipa_cmd.c
 create mode 100644 drivers/net/ipa/ipa_cmd.h
 create mode 100644 drivers/net/ipa/ipa_data-sc7180.c
 create mode 100644 drivers/net/ipa/ipa_data-sdm845.c
 create mode 100644 drivers/net/ipa/ipa_data.h
 create mode 100644 drivers/net/ipa/ipa_endpoint.c
 create mode 100644 drivers/net/ipa/ipa_endpoint.h
 create mode 100644 drivers/net/ipa/ipa_gsi.c
 create mode 100644 drivers/net/ipa/ipa_gsi.h
 create mode 100644 drivers/net/ipa/ipa_interrupt.c
 create mode 100644 drivers/net/ipa/ipa_interrupt.h
 create mode 100644 drivers/net/ipa/ipa_main.c
 create mode 100644 drivers/net/ipa/ipa_mem.c
 create mode 100644 drivers/net/ipa/ipa_mem.h
 create mode 100644 drivers/net/ipa/ipa_modem.c
 create mode 100644 drivers/net/ipa/ipa_modem.h
 create mode 100644 drivers/net/ipa/ipa_qmi.c
 create mode 100644 drivers/net/ipa/ipa_qmi.h
 create mode 100644 drivers/net/ipa/ipa_qmi_msg.c
 create mode 100644 drivers/net/ipa/ipa_qmi_msg.h
 create mode 100644 drivers/net/ipa/ipa_reg.c
 create mode 100644 drivers/net/ipa/ipa_reg.h
 create mode 100644 drivers/net/ipa/ipa_smp2p.c
 create mode 100644 drivers/net/ipa/ipa_smp2p.h
 create mode 100644 drivers/net/ipa/ipa_table.c
 create mode 100644 drivers/net/ipa/ipa_table.h
 create mode 100644 drivers/net/ipa/ipa_uc.c
 create mode 100644 drivers/net/ipa/ipa_uc.h
 create mode 100644 drivers/net/ipa/ipa_version.h
 create mode 100644 drivers/remoteproc/qcom_q6v5_ipa_notify.c
 create mode 100644 include/linux/remoteproc/qcom_q6v5_ipa_notify.h

-- 
2.20.1
