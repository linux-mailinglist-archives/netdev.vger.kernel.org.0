Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344FF24C356
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgHTQ2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729759AbgHTQ2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:28:45 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8035C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:28:44 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id r7so1387302vsq.5
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2e5oCxTrf5OuUJbLv9FM2E02dmTD3YkTfM5t/5yaJO4=;
        b=O0i8cLbLeXk734reUrekfX8VQ5fFB429Rdl8xTc0X27s5Cv2r9UwX8D5vUHoe0nM1T
         MJ4Hj7AhGQ+Iraco8oxZ229NvelfRZsOyigMyKRrdkTuWl25iq2Lcg1b165HDuK5oojZ
         mh7iKQEUNtwJc0mgNOlj3cOg09L3pSrgZ39cM5hSH9ssy4PHXlSgBtCrWDJVLb1hsinQ
         S5b4aOIXw3oDV3RQ+i2NSOPlldGZ+mcE+o5HotDvUPEhJLUy+jCdhm7bltPY5satJA0S
         5xHq8bl5uxBj3/twh2v8WUyfbQUG9Tp2a8wK5MvRjOMrNWqxObysBGrRDCWNDYC+8rjC
         JOuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2e5oCxTrf5OuUJbLv9FM2E02dmTD3YkTfM5t/5yaJO4=;
        b=Q0zSrG/+w9hEHXwab2fXHiyC/SvatI7oVl1QhVLr9H76Yauc7YjaumjAlXmrSYdLV5
         9H1RnTry9q/yqjH9IrkKy60omVKpJoeNjewX3V0o2isNac+gnnsqY+MMVO+bW+xcdtiG
         MxfSi7IA0mQ0Pwc0ew4f4EqkTBxwlswcqVOXm2MJAulGFH68X0srCLS23AnOmWdNVvCI
         3QH+LDKqkM7Y3uVgaoKyUmleYqgOBY+hY5d/7dY84HS7lZ5YNqwXvmMfhsv8MlZzUjFH
         oA5sr0h4uqSyIMYkKR+OoBoF5lGC/ayVuxKy0MofKzeSMBPoTaZt4lIBa4fqndq0SlYT
         0RnA==
X-Gm-Message-State: AOAM532ApOf23j57G3Rp7n9BH34Td9p9gQqKTSbfNWxO6eWNhV88Lo7i
        Mu9LcvBl47zFQBVHLnxlKnQPxsEsfI0RTkgGNWwaFHrBauKaSQ==
X-Google-Smtp-Source: ABdhPJxbTVc6fRXVRCGPj3zlthz7XovhWms9MZP5clDzEcvh3UzyG43luQ4q0ErdJTmttUeD1B7hOXngBiMaEEk2Gyc=
X-Received: by 2002:a67:d009:: with SMTP id r9mr2626388vsi.132.1597940923544;
 Thu, 20 Aug 2020 09:28:43 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Thu, 20 Aug 2020 12:28:32 -0400
Message-ID: <CAH6h+hceDweydEtSV8jXs15oqXMMNH+YZxzo+wZ3_MR9-Uqw4g@mail.gmail.com>
Subject: bnxt_en 0000:01:09.1 s1p2: hwrm req_type 0xe0 seq id 0xcdf error 0x3
To:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm using vanilla Linux 5.4.45 in a QEMU/KVM virtual machine. This
virtual machine has VF's from a Broadcom BCM57416 passed into it (via
PCI pass-through). We see messages like these in the kernel log very
frequently:
...
[45171.097040] bnxt_en 0000:01:09.0 s1p1: hwrm req_type 0xe0 seq id
0xcde error 0x3
[45171.098279] bnxt_en 0000:01:09.1 s1p2: hwrm req_type 0xe0 seq id
0xcde error 0x3
[45186.098663] bnxt_en 0000:01:09.0 s1p1: hwrm req_type 0xe0 seq id
0xcdf error 0x3
[45186.100161] bnxt_en 0000:01:09.1 s1p2: hwrm req_type 0xe0 seq id
0xcdf error 0x3
...

If I've used the decoder ring correctly, these appear to be the
req_type and error values:
req_type -> HWRM_TEMP_MONITOR_QUERY
error -> HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED

This only occurs for the virtual functions, and those messages appear
in both the virtual machines that use the VF's (via PCI pass-through)
and VF's that are not passed through into VM's (eg, still present and
unused at the hypervisor level). I don't see these messages for the
PF's.

I can trigger the kernel log entries above by doing the following on
an hwmon sysfs entry for one of the VF's:
# cat /sys/class/hwmon/hwmon0/device/hwmon/hwmon0/temp1_input

So I assume this is because VF's don't have access to the temperature
sensors, either by design or something else is misconfigured. If this
is expected for VF's, perhaps we could set those messages to silent if
it's a VF PCI ID? Or handle this in bnxt_hwmon_open() if it's a VF PCI
ID (eg, not do anything)?

This certainly isn't causing any problems, so not high priority, but
the messages aren't pretty to look at. =)


PF device information:
# bnxtnvm -dev=em1 device_info

Device Interface Name     : em1
MACAddress                : 3c:ec:ef:45:98:82
Part Number               : BCM57416
Description               : N/A
PCI Vendor Id             : 14e4
PCI Device Id             : 16d8
PCI Subsys Vendor Id      : 15d9
PCI Subsys Device Id      : 16d8
PCI Device Name           : 0000:c8:00.0
Adapter Rev               : 01
Active Package version    : N/A
Package version on NVM    : N/A
bnxtnvm_get_nvm_cfg_version status = -1 ver = 0.0.0
NVM config version        : N/A
bnxtnvm_get_active_cfg_version status = 0
Active NVM config version : 0.0.0
Firmware Reset Counter    : Not Available
Error Recovery Counter    : Not Available
Crash Dump Timestamp      : Not Available
Reboot Required           : No

# ethtool -i em1
driver: bnxt_en
version: 1.10.1-216.0.169.4
firmware-version: 214.0.191.0
expansion-rom-version:
bus-info: 0000:c8:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no


Thanks for your time.


--Marc
